//
//  ViewController.swift
//  Weather
//
//  Created by Wuz Good on 19.08.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableview: UITableView!
    var model = Model()    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        tableview.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableview.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return model.daily.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: model.hourly)
            cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
            return cell
        }
        // daily weather cells
        let cell = tableview.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: model.daily[indexPath.row])
        cell.backgroundColor = UIColor(white: 1, alpha: 0.1)
        
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
