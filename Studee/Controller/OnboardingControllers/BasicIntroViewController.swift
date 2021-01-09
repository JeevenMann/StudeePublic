//
//  BasicIntroViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-31.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit

protocol onboardingProtocol: UIViewController {
    func presentLogin()
    func nextScreen()
}

class BasicIntroViewController: UIViewController {
    
    @IBOutlet private weak var largeText: UITextView!
    @IBOutlet private weak var smallText: UILabel!
    @IBOutlet private weak var flatImage: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    
    weak var delegate: onboardingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ smallText: String, _ largeText: String, _ flatImage: UIImage) {
        // Force VC to load it's view and set the UI elements
        _ = self.view
        self.largeText.text = largeText
        self.smallText.text = smallText
        self.flatImage.image = flatImage
    }
    
    @IBAction private func skipDialog(_ sender: Any) {
        // Skip the entire page view controller and present login/signup buttons
        delegate?.presentLogin()
    }
    
    @IBAction private func nextScreen(_ sender: Any) {
        // Go to the next screen in the pageVC
        delegate?.nextScreen()
    }
}
