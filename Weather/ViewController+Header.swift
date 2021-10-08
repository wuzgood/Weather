//
//  ViewController+Header.swift
//  Weather
//
//  Created by Wuz Good on 08.10.2021.
//

import Foundation
import UIKit

extension ViewController {
    func createHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width - 60))
        
        let temperature = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 40, width: view.frame.width, height: 80))
        let summary = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 85, width: view.frame.width, height: 40))
        let location = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 140, width: view.frame.width, height: 60))
        let minMaxTemp = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 + 50, width: view.frame.width, height: 40))
        
        header.addSubview(location)
        header.addSubview(summary)
        header.addSubview(temperature)
        header.addSubview(minMaxTemp)
        
        location.textAlignment = .center
        location.font = UIFont.systemFont(ofSize: 50, weight: .light)
        
        summary.textAlignment = .center
        summary.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        temperature.textAlignment = .center
        temperature.font = UIFont.systemFont(ofSize: 100, weight: .light)
        
        minMaxTemp.textAlignment = .center
        minMaxTemp.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        // cutting region name from location title: Europe/Kiev -> Kiev
        let cityName = model.locationTitle?.components(separatedBy: "/")[1]
        location.text = cityName?.replacingOccurrences(of: "_", with: " ")
        
        summary.text = model.currentWeather?.weather[0].description.capitalized
        
        let temp = Int(model.currentWeather?.temp ?? 0)
        temperature.text = " \(temp)°"
        
        let minTemp = Int(model.currentTemp?.min ?? 0)
        let maxTemp = Int(model.currentTemp?.max ?? 0)
        minMaxTemp.text = "Max. \(maxTemp)°, min. \(minTemp)°"
        
        return header
    }
}
