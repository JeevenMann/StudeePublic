//
//  UIViewController Extension.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-29.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        // Create gesture recognizer to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
 
        func getTB() -> ESTabBarController? {
            // Return the main TB after login
            
            // safely initialize all the vc's
            if let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController,
               let tabBar = storyboard?.instantiateViewController(identifier: "mainTB") as? ESTabBarController,
               let qnaVC = storyboard?.instantiateViewController(identifier: "qnaVC") as? QNAViewController,
               let newsVC = storyboard?.instantiateViewController(identifier: "forumVC") as? ForumViewController,
               let timerVC = storyboard?.instantiateViewController(identifier: "timerVC") as? TimerViewController,
               let userVC = storyboard?.instantiateViewController(identifier: "userVC") as? UserViewController {

                // assign tab bar item images and titles
                homeVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Home", image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"), tag: 2)
                timerVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Focus", image: UIImage(named: "Clock"), selectedImage: UIImage(named: "Clock"), tag: 3)
                qnaVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "Q&A", image: UIImage(named: "QNA"), selectedImage: UIImage(named: "QNA"), tag: 0)
                newsVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "News", image: UIImage(named: "News"), selectedImage: UIImage(named: "News"), tag: 1)
                userVC.tabBarItem = ESTabBarItem(ExampleBouncesContentView(), title: "User", image: UIImage(named: "User"), selectedImage: UIImage(named: "User"), tag: 4)

            //set VC's and selected index and return
            tabBar.viewControllers = [qnaVC, newsVC, homeVC, timerVC, userVC]
            tabBar.selectedIndex = 1
            return tabBar
           }
            return nil
        }
}
