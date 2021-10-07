//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Wuz Good on 01.09.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    
    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: HourlyWeather) {
        // dark mode support
        /*
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return .black
            case .dark:
                return .white
            @unknown default:
                return .black
            }
         
        }
        */
        self.tempLabel.text = " \(Int(model.temp))°"
        guard let weatherIcon = model.weather.first?.main else { return }
        self.iconImageView.image = UIImage(named: weatherIcon)

//        self.iconImageView.image = UIImage(named: weatherIcon)?.withTintColor(dynamicColor)
        self.iconImageView.contentMode = .scaleAspectFit
        self.hourLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))

    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: date)
    }

}
