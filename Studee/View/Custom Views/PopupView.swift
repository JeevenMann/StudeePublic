//
//  PopupView.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-05.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class PopupView: UIView {

     init(frame: CGRect, text: String, image: UIImage) {

        super.init(frame: frame)
        
        // Modify View Properties
        self.layer.cornerRadius = 10

        self.backgroundColor = UIColor(named: "Accent1")

        // Declare imageview and it's properties/constraints
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width * 0.25, height: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        let centerConstraint = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: self.bounds.width * 0.25)
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, leadingConstraint, centerConstraint])

        // Declare the textView and it's properties/constraints
        let textLabel = UITextView()
        textLabel.text = text
        textLabel.font = UIFont(name: "MaisonNeue-DemiBold", size: 15)
        textLabel.isEditable = false
        textLabel.isScrollEnabled = false
        textLabel.backgroundColor = .clear
        textLabel.textAlignment = .left
        self.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelHeightConstraint = NSLayoutConstraint(item: textLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: -15)
        let labelCenterConstraint = NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let labelWidthConstraint = NSLayoutConstraint(item: textLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: self.bounds.width - imageView.bounds.width - 10 )
        let labelLeadingConstraint = NSLayoutConstraint(item: textLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 10)
        let trailingConstraint = NSLayoutConstraint(item: textLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
        NSLayoutConstraint.activate([labelHeightConstraint, labelWidthConstraint, labelLeadingConstraint, labelCenterConstraint, trailingConstraint])
    }
    
    override func layoutSubviews() {
        // Once the subviews have been laied out
        // Move and then dismiss the popup
        self.movePopup()
        self.dismiss()
    }
    
    func dismiss() {
        // Dismiss the view
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = 0
        }, completion: nil)
    }

    func movePopup() {
        // Transition the view to appear from the bottom of the screen
        let bottomY = self.superview?.bounds.maxY ?? 0 + self.bounds.height
        let bottomX = self.superview?.center.x ?? 0
        self.center = CGPoint(x: bottomX, y: bottomY)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            
            self?.center = CGPoint(x: bottomX, y: bottomY - (self?.bounds.height ?? 0 + 20))
        }, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
