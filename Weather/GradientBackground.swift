//
//  GradientBackground.swift
//  Weather
//
//  Created by Wuz Good on 07.10.2021.
//

import Foundation
import UIKit

class GradientBackground {
    var isGradientSet = false

    func setup(vc: ViewController, temperature: Double?) {
        if isGradientSet {
                vc.view.layer.sublayers?.remove(at: 0)
        }
        
        if let temp = temperature {
            // calculate the hue color
            let gradientTemp = (temp + 30) * 4
            
            let color1 = UIColor(hue: 1-((gradientTemp + 20)/255), saturation: 1, brightness: 1, alpha: 1).cgColor
            let color2 = UIColor(hue: 1-((gradientTemp + 10)/255), saturation: 1, brightness: 1, alpha: 1).cgColor
            let color3 = UIColor(hue: 1-(gradientTemp/255), saturation: 1, brightness: 1, alpha: 1).cgColor

            let colors = [color1, color2, color3]

            let viewLayer = vc.view.layer
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.frame = viewLayer.bounds
            
            viewLayer.insertSublayer(gradientLayer, at: 0)

            if !isGradientSet {
                isGradientSet = true
            }
        }
    }
}
