// IntroViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-31.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit

class IntroViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: View Functions/Variables
    var introOneVC: BasicIntroViewController {
        // First VC in PageView
        let introVC = BasicIntroViewController(nibName: "BasicIntroViewController", bundle: nil)
        introVC.setData("Learn at your own pace!", "With tons of content to watch, you can pace yourself and own your knowledge.", UIImage(named: "FlatLearn")!)
        introVC.delegate = self

        return introVC
    }
    var introTwoVC: BasicIntroViewController {
        // Second VC in PageView
        let introVC = BasicIntroViewController(nibName: "BasicIntroViewController", bundle: nil)
        introVC.setData("Stuck on a problem?", "Post a question to the forum and the studee community will help.", UIImage(named: "FlatBlog")!)
        introVC.delegate = self
        return introVC
    }
    var introThreeVC: BasicIntroViewController {
        // Third VC in PageView
        let introVC = BasicIntroViewController(nibName: "BasicIntroViewController", bundle: nil)
        introVC.setData("Trouble Focusing?", "Use our pomodoro timer to keep yourself productive, while having breaks.", UIImage(named: "FlatFocus")!)
        introVC.delegate = self
        return introVC
    }
    
    var introLastVC: LastSwipeViewController? {
        // Last VC in PageView
        // Has login and signup buttons
        if let lastVC = self.storyboard?.instantiateViewController(identifier: "lastVC") as? LastSwipeViewController {
            return lastVC
        }
        return nil
    }

    // Declare variables for VC's
    var introVCArray: [UIViewController] = []
    var vcIndex = 0

    override func viewDidLoad() {
        // Set pageVC delegate
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        // Set appearance of bottom dots
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.white
        appearance.currentPageIndicatorTintColor = UIColor(named: "Accent1")
        self.view.backgroundColor = UIColor(named: "BackgroundColor")

        // Initialize the first VC into array
        self.introVCArray = [introOneVC]

        // Set the first VC and then add the other VC's
        self.setViewControllers(introVCArray, direction: .forward, animated: true, completion: nil)
        self.introVCArray.append(introTwoVC)
        self.introVCArray.append(introThreeVC)

        if let lastVC = introLastVC {
            self.introVCArray.append(lastVC)
        }

    }
}
// MARK: Extensions
extension IntroViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Load the VC that will be loaded previous to the current one
        // Get the index of the current VC being displayed
        guard let prevVCIndex = self.introVCArray.firstIndex(of: viewController) else {
            return nil
        }

        // if the current VC exists in the array and is not the first element continue else return nil
        guard prevVCIndex > 0 else {
            return nil
        }

        // Set the vcIndex to the previous index
        vcIndex = prevVCIndex - 1

        // return the previous element
        return introVCArray[vcIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Load the VC that will be loaded next to the current one
        // Get the index of the current VC being displayed
        guard let nextVCIndex = self.introVCArray.firstIndex(of: viewController) else {
            
            return nil
        }
        // if the current VC exists in the array and is not the first element continue else return nil
        guard nextVCIndex < 3 else {
            return nil
        }
        // Set the vcIndex to the next index
        vcIndex = nextVCIndex + 1

        // return the next element
        return introVCArray[vcIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.introVCArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // To programmatically move to a VC we need to return the vcIndex that the pageVC has moved to
        return vcIndex
    }
}
// MARK: Extension
extension IntroViewController: onboardingProtocol {
    func presentLogin() {
        // Set the vcIndex to the last VC
        // Set the lastVC to the pageVC
        self.vcIndex = 3
        self.setViewControllers([self.introVCArray.last!], direction: .forward, animated: true, completion: nil)
    }

    func nextScreen() {
        // Function to go to the next VC when the arrow is pressed in the VC

        // Get the current VC being presented
        guard let currentVC = self.viewControllers?.first else {
            print("Error")
            return
        }

        // Get the next screen to present
        guard let nextScreenVC = self.pageViewController(self, viewControllerAfter: currentVC) else {
            print("Error")
            return
        }
        
        self.setViewControllers([nextScreenVC], direction: .forward, animated: true, completion: nil)
    }
}
