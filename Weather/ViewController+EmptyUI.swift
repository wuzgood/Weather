//
//  ViewController+EmptyUI.swift
//  Weather
//
//  Created by Wuz Good on 08.10.2021.
//

import Foundation
import UIKit

extension ViewController {

    func presentNoLocationView() {
        if model.locationTitle == nil {
            noLocationView = UILabel(frame: CGRect(x: 0, y: 0 , width: 0, height: 0))
            
            guard let noLocationView = noLocationView else { return }
            noLocationView.text = "No location found"
            noLocationView.textAlignment = .center
            noLocationView.backgroundColor = UIColor(white: 1, alpha: 0.1)
            noLocationView.sizeToFit()
            noLocationView.layer.position = CGPoint(x: view.center.x, y: 50)

            view.addSubview(noLocationView)
                            
            presentNoLocationAlert()
            
            return
        }
    }
    
    func presentNoLocationAlert() {
        let ac = UIAlertController(title: "No location found", message: "Check your internet connection or location access.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: { [weak self]_ in
            ac.dismiss(animated: true)
            self?.setup()
            
            if self?.model.locationTitle == nil {
                self?.presentNoLocationAlert()
            }
        }))
        present(ac, animated: true)
    }
    
    
}
