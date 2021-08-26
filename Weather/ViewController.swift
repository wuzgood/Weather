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
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var currentWeather: CurrentWeather?
    var currentTemp: Temp?
    var locationTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register 2 cells
        tableview.register(HourTableViewCell.nib(), forCellReuseIdentifier: HourTableViewCell.identifier)
        tableview.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getLocation()
        
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
            
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else { return }
            
            let entries = result.daily
            self.models.append(contentsOf: entries)

            self.currentWeather = result.current
            self.locationTitle = result.timezone
            self.currentTemp = result.daily[0].temp
            
            // update UI
            DispatchQueue.main.async {
                self.tableview.reloadData()
                
                self.tableview.tableHeaderView = self.createHeader()
            }
            
        }.resume()
    }
    
    func createHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width))
        
        let temperature = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 40, width: view.frame.width, height: 80))
        let summary = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 80, width: view.frame.width, height: 40))
        let location = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 - 140, width: view.frame.width, height: 60))
        let minMaxTemp = UILabel(frame: CGRect(x: 0, y: header.frame.height / 2 + 40, width: view.frame.width, height: 40))
        
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
                
        location.text = locationTitle
        summary.text = currentWeather?.weather[0].description.capitalized
        
        let temp = Int(currentWeather?.temp ?? 0)
        temperature.text = "\(temp)°"
        
        let minTemp = Int(currentTemp?.min ?? 0)
        let maxTemp = Int(currentTemp?.max ?? 0)
        minMaxTemp.text = "Max. \(maxTemp)°, min. \(minTemp)°"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    struct WeatherResponse: Codable {
        let lat: Float
        let lon: Float
        let timezone: String
        let current: CurrentWeather
        let hourly: [HourlyWeather]
        let daily: [DailyWeather]
    }
    
    struct CurrentWeather: Codable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
//        let wind_gust: Double
        let weather: [Weather]
    }
    
    struct HourlyWeather: Codable {
        let dt: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
//        let wind_gust: Double
        let weather: [Weather]
    }
    
    struct DailyWeather: Codable {
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let moonrise: Int
        let moonset: Int
        let moon_phase: Double
        let temp: Temp
        let feels_like: FeelsLike
        let pressure: Int
        let humidity: Int
        let dew_point: Double
        let wind_speed: Double
        let wind_deg: Int
//        let wind_gust: Double
        let weather: [Weather]
        let clouds: Int
        let uvi: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Temp: Codable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    struct FeelsLike: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
}

