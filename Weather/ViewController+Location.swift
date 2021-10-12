//
//  ViewController+Location.swift
//  Weather
//
//  Created by Wuz Good on 08.10.2021.
//

import Foundation
import UIKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    
    func setup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty {
            currentLocation = locations.first
            weatherRequest()
        }
        
        if let noLocationView = noLocationView {
            noLocationView.removeFromSuperview()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️")
        print(error.localizedDescription)
        
        presentNoLocationView()
    }
    
    func weatherRequest() {
        guard let currentLocation = currentLocation else { return }
        
        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&units=metric&appid=6ca4091b1be6cd9905e8e10ec4667e63"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                print("a problem occured")
                return
            }
            
            var weatherResponse: WeatherResponse?
            do {
                weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                let dateString = formatter.string(from: Date())

                print("\(dateString) Decoding successful")
                
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = weatherResponse else { return }
            
            var entries = result.daily
            // removing current day from daily weather forecast
            entries.remove(at: 0)
            
            if self.model.daily.isEmpty {
                self.model.daily.append(contentsOf: entries)
                self.locationManager.stopUpdatingLocation()
            }
            
            self.model.currentWeather = result.current
            self.model.locationTitle = result.timezone
            self.model.currentTemp = result.daily[0].temp
            
            self.model.hourly = result.hourly
            self.model.hourly.removeSubrange(25...self.model.hourly.count-1)
            
            // update UI
            DispatchQueue.main.async {
                self.tableview.reloadData()
                
                self.tableview.tableHeaderView = self.createHeader()
                
                let gradient = GradientBackground()
                gradient.setup(vc: self)
            }
            
        }.resume()
    }
}
