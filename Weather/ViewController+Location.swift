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
        
        updateLocation()
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.updateLocation()
            print(timer.fireDate)
        }
//        locationManager.startUpdatingLocation()
    }
    
    func updateLocation() {
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("🌎")
        print(locations)
        
        if !locations.isEmpty {
            currentLocation = locations.first
            weatherRequest()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️")
        print(error.localizedDescription)
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
