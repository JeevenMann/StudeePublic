//
//  TimerViewController.swift
//  Study Timer
//
//  Created by Navjeeven Mann on 2020-05-22.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import GaugeKit
import GoogleMobileAds
import ESTabBarController_swift
class TimerViewController: UIViewController, GADInterstitialDelegate, GADBannerViewDelegate {

    // MARK: IBOutlet Variables/Functions
    @IBOutlet private weak var sessionView: UIView!
    @IBOutlet private weak var sprintView: UIView!
    @IBOutlet private weak var adBanner: GADBannerView!
    @IBOutlet private weak var sessionGauge: Gauge!
    @IBOutlet private weak var sprintGauge: Gauge!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var timeView: UIView!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var minuteLabel: UILabel!
    @IBOutlet private weak var adBannerBottom: NSLayoutConstraint!

    @IBAction private func startButtonPressed(_ sender: Any) {
        if flag {
            self.startCountDown()
            flag = false
            self.startButton.setImage(UIImage(named: "Stop"), for: .normal)
        } else {
            self.timer?.invalidate()
            flag = true
            self.startButton.setImage(UIImage(named: "Start"), for: .normal)
        }
    }

    // MARK: View Variables/Functions
    let countDown: CountdownTimer = CountdownTimer.sharedInstance
    var tabBar: UITabBar?
    var flag: Bool = true
    var fullScreenAd: GADInterstitial!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set initial values for labels and max value based on the users preference
        setInitialLabelConditions()
        sprintGauge.maxValue = CGFloat(User.sharedInstance.sprintTarget)
        sessionGauge.maxValue = CGFloat(User.sharedInstance.sessionTarget)

        // Set inital value for both gauges
        self.updateRate()

        // Initialize ad views and delegates
        adBanner = AdManager.sharedInstance.createAndLoadBanner(adBanner)
        adBanner.rootViewController = self
        adBanner.delegate = self
        fullScreenAd = AdManager.sharedInstance.createAndLoadInterstitial()
        fullScreenAd.delegate = self
    }

    func setInitialLabelConditions() {
        // Set the initial values for the labels
        timeView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
        minuteLabel.adjustsFontSizeToFitWidth = true
        minuteLabel.minimumScaleFactor = 1
        secondLabel.adjustsFontSizeToFitWidth = true
        secondLabel.minimumScaleFactor = 1
        self.minuteLabel.text = String(format: "%02d", countDown.sprintTime)
        self.secondLabel.text = String(format: "%02d", countDown.seconds)

        // Move the adBanner up based on how tall the tabBar is
        adBannerBottom.constant += tabBar?.frame.size.height ?? 0
    }

    func startCountDown() {
        // Initialzie the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in

            // Change values and update the labels
            self.countDown.countdown()
            self.minuteLabel.text = String(format: "%02d", self.countDown.sprintTime)
            self.secondLabel.text = String(format: "%02d", self.countDown.seconds)

            // If we have reached the end of timer invalidate and update the status of the timer
            if self.countDown.sprintTime == 0 && self.countDown.seconds == 0 {
                timer.invalidate()
                self.gaugeControl()
            }
        })
    }

    func gaugeControl() {

        // if the bool value returns true present a fullScreenad
        if Bool.random() {
            fullScreenAd.present(fromRootViewController: self)
        }

        // Change the status of the timer and the values for the gauges
        // And start the countdown again
        self.countDown.timerControl()
        self.updateRate()
        self.startCountDown()

        // Change background based on the timer status
        UIView.animate(withDuration: 1.0, animations: {
            switch self.countDown.timerStatus {
            case .longBreak:
                self.view.backgroundColor = .blue
                self.sessionView.backgroundColor = .blue
                self.sprintView.backgroundColor = .blue
                
            case .shortBreak:
                self.view.backgroundColor = .red
                self.sessionView.backgroundColor = .red
                self.sprintView.backgroundColor = .red

            case .normal:
                self.view.backgroundColor = .black
                self.sessionView.backgroundColor = .black
                self.sprintView.backgroundColor = .black
            }
        })
    }
    
    func updateRate() {
        // Update the values for the guages
        self.sessionGauge.rate = CGFloat(User.sharedInstance.sessionRate)
        self.sprintGauge.rate = CGFloat(User.sharedInstance.sprintRate)
    }
    
    // MARK: Ad Delegate Methods
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // Load the next fullScreen ad once the current one has been dismissed
        fullScreenAd = AdManager.sharedInstance.createAndLoadInterstitial()
    }
}
