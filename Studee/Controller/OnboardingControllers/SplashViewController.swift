//
//  SplashViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-01.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {

    // MARK: IB Outlet/Actions

    @IBOutlet private weak var getStartedButton: UIButton!

    @IBAction private func startClick(_ sender: Any) {

        if let pageView = self.storyboard?.instantiateViewController(identifier: "introVC") as? IntroViewController {
            self.navigationController?.setViewControllers([pageView], animated: true)
        }
    }

    // MARK: View Function/Variables

    var avplayerContext = 0
    var videoPlayer: AVPlayer?
    var overlayView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.layer.cornerRadius = 15
        // Add background video
        let videoView = AVPlayerLayer(player: videoPlayer)
        videoView.frame = view.bounds
        videoView.videoGravity = .resizeAspectFill
        videoPlayer?.isMuted = true
        videoPlayer?.automaticallyWaitsToMinimizeStalling = false
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
        self.view.layer.addSublayer(videoView)
        
        // Add Observers
        videoPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: .new, context: &avplayerContext)
        NotificationCenter.default.addObserver(self, selector: #selector(videoFinish), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(videoPlay), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // Create Studee Label
        let logoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 15))
        logoLabel.text = "studee"
        logoLabel.textColor = UIColor(named: "Accent1")
        logoLabel.font = UIFont(name: "MaisonNeue-DemiBold", size: 30)
        self.view.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingAnchor = NSLayoutConstraint(item: logoLabel, attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 10)
        let topAnchor = NSLayoutConstraint(item: logoLabel, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
        NSLayoutConstraint.activate([leadingAnchor, topAnchor])
        self.view.bringSubviewToFront(getStartedButton)

        // Add Generic Text
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        textLabel.text = "Education at your fingertips."
        textLabel.textColor = UIColor(named: "Accent1")
        textLabel.font = UIFont(name: "MaisonNeue-DemiBold", size: 30)
        self.view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let leadingConstraint = NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let yConstraint = NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: getStartedButton, attribute: .top, multiplier: 1, constant: -20)
        NSLayoutConstraint.activate([widthConstraint, yConstraint, leadingConstraint])

        // Overlay loading UIView to smoothly present AVPlayerLayer
        overlayView = UIView(frame: self.view.bounds)
        overlayView?.backgroundColor = UIColor(named: "BackgroundColor")
        self.view.addSubview(overlayView!)
    }

    @objc  func videoFinish() {
        // Loop video back to beginning
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
    }
    
    @objc func videoPlay() {
        // Play the video
        self.videoPlayer?.play()
    }
    
    @objc func videoLoaded() {
        if let overlay = overlayView {
            UIView.transition(with: overlay, duration: 0.75, options: .curveEaseIn, animations: {
                overlay.alpha = 0
            }, completion: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Depending on the enum value if the video is ready to play
        // remove the overlay and play the video
        if context == &avplayerContext {
            
            if let type = change?[.newKey] as? Int {

                if type == 1 {
                    videoLoaded()
                }
            }
        }
    }
}
