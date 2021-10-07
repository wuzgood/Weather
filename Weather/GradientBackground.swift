//
//  GradientBackground.swift
//  Weather
//
//  Created by Wuz Good on 07.10.2021.
//

import Foundation
import UIKit
//import CoreGraphics

class GradientBackground {
    let viewFrame = UIScreen.main.bounds
    
    func setGradient() {
        let gradientLayer = CAGradientLayer()
        let colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]

        gradientLayer.colors = colors
    }
    
    
}
