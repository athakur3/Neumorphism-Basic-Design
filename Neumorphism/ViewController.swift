//
//  ViewController.swift
//  Neumorphism
//
//  Created by Akshansh Thakur on 20/07/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var playerImageView: UIView!
    @IBOutlet weak var songLogo: UIImageView!
    
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideHandle: UIButton!
    
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradientLayer()
        setNeumorphicButtons()
        setupPlayerView()
        setupHandleRadialLayer()
        
    }
    
    fileprivate func setupHandleRadialLayer() {
        let radialGradient = CAGradientLayer()
        radialGradient.type = .radial
        radialGradient.frame = slideHandle.bounds
        radialGradient.colors = [
            UIColor.tickYellow.withAlphaComponent(0.7).cgColor,
            UIColor.tickYellow.cgColor,
            UIColor.darkText.cgColor,
            UIColor.darkBlack.cgColor,
        ]
        
        radialGradient.locations = [0, 0.32, 0.32, 1.0]
        
        radialGradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        radialGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        radialGradient.cornerRadius = slideHandle.bounds.height / 2.0
        
        slideHandle.layer.cornerRadius = slideHandle.bounds.height / 2.0
        slideHandle.layer.insertSublayer(radialGradient, at: 0)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slidePanGesture))
        slideHandle.addGestureRecognizer(panGestureRecognizer)
        
        slideHandle.makeOutwardNeomorphic(reversed: false, offsetValue: 4.0, cornerRadius: slideHandle.bounds
            .height / 2.0, shadowRadius: 4.0, alphaLight: 0.1, alphaDark: 0.1)
        
    }
    
    var currentPosition: CGFloat = 0.0
    
    @objc func slidePanGesture(gesture: UIPanGestureRecognizer) {
                
        let translation = gesture.translation(in: slideHandle).x
        
        let nextPosition = translation + self.currentPosition
        
        let offset = CGFloat(18.0)
        
        let threshHold = offset...(slideView.frame.width - offset)
        
        switch gesture.state {
        
        case .changed:
            
            if threshHold.contains(nextPosition) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.slideHandle.center.x = nextPosition
                }) { (value) in
                    self.view.layoutIfNeeded()
                }
            }
            
        case .ended:
            
            if nextPosition < offset {
                currentPosition = offset
            } else if nextPosition > slideView.frame.width - offset {
                currentPosition = slideView.frame.width - offset
            } else {
                currentPosition += translation
            }
            
        default:
            break
        }
        
    }
    
    func addGradientLayer() {
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.lightBlack.cgColor, UIColor.darkBlack.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    fileprivate func setupPlayerView() {
        playerImageView.backgroundColor = UIColor.darkBlack
        playerImageView.layer.cornerRadius = playerImageView.bounds.width / 2.0
        
        playerImageView.makeOutwardNeomorphic(reversed: false, offsetValue: 15.0, shadowRadius: 15.0, alphaLight: 0.1, alphaDark: 0.2)
        
        songLogo.contentMode = .scaleToFill
        songLogo.layer.cornerRadius = songLogo.bounds.width / 2.0
        songLogo.layer.masksToBounds = true
    }
    
    
    fileprivate func performBaseButtonFunctions(button: UIButton?, startColor: UIColor = UIColor.lightBlack, endColor: UIColor = UIColor.darkBlack) {
        
        guard let thisButton = button else {return}
        
        thisButton.layer.cornerRadius = backButton.bounds.height / 2.0
        
        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = thisButton.bounds
        buttonGradient.colors = [startColor.cgColor, endColor.cgColor]
        buttonGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        buttonGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        buttonGradient.cornerRadius = thisButton.bounds.height / 2.0
        
        thisButton.layer.insertSublayer(buttonGradient, at: 0)
        
    }
    
    fileprivate func setNeumorphicButtons() {
        
        [backButton, menuButton, reverseButton, forwardButton, playButton].forEach { (button) in
            
            if let thisButton = button, thisButton == playButton {
                performBaseButtonFunctions(button: thisButton, startColor: .mellowOrange, endColor: .mellowOrange)
                
                thisButton.makeOutwardNeomorphic(reversed: true, offsetValue: 1.0, cornerRadius: menuButton.bounds.height / 2.0, shadowRadius: 1.0, alphaLight: 0.05, alphaDark: 0.1)
                
                thisButton.tintColor = .white
                
                if let image = thisButton.imageView {
                    thisButton.bringSubviewToFront(image)
                }
                
                thisButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                
                self.view.layoutIfNeeded()
                
            } else {
                performBaseButtonFunctions(button: button)
                
                button?.makeOutwardNeomorphic(reversed: true, offsetValue: 3.0, cornerRadius: menuButton.bounds.height / 2.0, shadowRadius: 3.0, alphaLight: 0.1, alphaDark: 0.4)
                
                if let image = button?.imageView {
                    button?.bringSubviewToFront(image)
                }
            }
            
        }
    }

}





