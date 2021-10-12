//
//  GradientBackground.swift
//  Weather
//
//  Created by Wuz Good on 07.10.2021.
//

import Foundation
import UIKit

class GradientBackground {

    func setup(vc: ViewController, temperature: Double?) {
        if let temp = temperature {
            // calculate the hue color
            let gradientTemp = (temp + 30) * 4
            
            let color1 = UIColor(hue: gradientTemp/255, saturation: 1, brightness: 1, alpha: 1).cgColor
            let color2 = UIColor(hue: (gradientTemp + 10)/255, saturation: 1, brightness: 1, alpha: 1).cgColor
            let color3 = UIColor(hue: (gradientTemp + 20)/255, saturation: 1, brightness: 1, alpha: 1).cgColor

            let colors = [color1, color2, color3]

            let viewLayer = vc.view.layer
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.frame = viewLayer.bounds
            
            viewLayer.insertSublayer(gradientLayer, at: 0)
        }
        
//        let color1 = UIColor(hue: gra, saturation: <#T##CGFloat#>, brightness: CGFloat, alpha: <#T##CGFloat#>)
//        let color2 = CGColor(red: 210/255, green: 133/255, blue: 70/255, alpha: 1)
//        let color3 = CGColor(red: 219/255, green: 103/255, blue: 53/255, alpha: 1)
        
//        let colors = [color1, color2, color3]
//
//        let viewLayer = vc.view.layer
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors
//        gradientLayer.frame = viewLayer.bounds
//
//        viewLayer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
