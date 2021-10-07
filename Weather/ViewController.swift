//
//  ViewController.swift
//  Weather
//
//  Created by Wuz Good on 19.08.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableview: UITableView!
    
    var models = [DailyWeather]()
    var hourlyModels = [HourlyWeather]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentWeather: CurrentWeather?
    var currentTemp: Temp?
    var locationTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register 2 cells
        tableview.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableview.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        //        setGradient()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gradient = GradientBackground()
        gradient.setup(vc: self)
        
        getLocation()
        
        //        setGradient()
    }
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty && currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            weatherRequest()
        } else {
            print("No location found")
        }
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
            self.models.append(contentsOf: entries)
            
            self.currentWeather = result.current
            self.locationTitle = result.timezone
            self.currentTemp = result.daily[0].temp
            
            self.hourlyModels = result.hourly
            self.hourlyModels.removeSubrange(25...self.hourlyModels.count-1)
            
            // update UI
            DispatchQueue.main.async {
                self.tableview.reloadData()
                
                self.tableview.tableHeaderView = self.createHeader()
            }
            
        }.resume()
    }
    
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
        let cityName = locationTitle?.components(separatedBy: "/")[1]
        location.text = cityName?.replacingOccurrences(of: "_", with: " ")
        
        summary.text = currentWeather?.weather[0].description.capitalized
        
        let temp = Int(currentWeather?.temp ?? 0)
        temperature.text = " \(temp)°"
        
        let minTemp = Int(currentTemp?.min ?? 0)
        let maxTemp = Int(currentTemp?.max ?? 0)
        minMaxTemp.text = "Max. \(maxTemp)°, min. \(minTemp)°"
        
        return header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return models.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = .clear
            return cell
        }
        // daily weather cells
        let cell = tableview.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableview.cellForRow(at: indexPath) as? WeatherTableViewCell {
            cell.flipCell()
        }
    }
}

