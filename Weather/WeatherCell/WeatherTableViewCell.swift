//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Wuz Good on 20.08.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: ViewController.DailyWeather) {
        self.minTempLabel.text = "\(Int(model.temp.min))°"
        self.maxTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        guard let weatherIcon = model.weather.first?.main else { return }
        
        // dark mode support
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
        self.iconImageView.image = UIImage(named: weatherIcon)?.withTintColor(dynamicColor)
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}
