//
//  Model.swift
//  Weather
//
//  Created by Wuz Good on 08.10.2021.
//

import Foundation

struct Model {
    var daily = [DailyWeather]()
    var hourly = [HourlyWeather]()
    
    var currentWeather: CurrentWeather?
    var currentTemp: Temp?
    var locationTitle: String?
}
