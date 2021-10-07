//
//  GradientBackground.swift
//  Weather
//
//  Created by Wuz Good on 07.10.2021.
//

import Foundation
import UIKit

class GradientBackground {
    func setup(vc: ViewController) {
        let color1 = CGColor(red: 229/255, green: 147/255, blue: 91/255, alpha: 1)
        let color2 = CGColor(red: 210/255, green: 133/255, blue: 70/255, alpha: 1)
        let color3 = CGColor(red: 219/255, green: 103/255, blue: 53/255, alpha: 1)
        
        let colors = [color1, color2, color3]
        
        let viewLayer = vc.view.layer
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = viewLayer.bounds
        
        viewLayer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
