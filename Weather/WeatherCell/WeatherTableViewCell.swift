//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Wuz Good on 20.08.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var normalView: UIView!
    @IBOutlet var flipView: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
   
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var cloudsLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    
    var viewFlipped = false

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
        // front cell view (normalView)
        self.minTempLabel.text = "\(Int(model.temp.min))°"
        self.maxTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        guard let weatherIcon = model.weather.first?.main else { return }
        
        // back cell view (flipView)
        self.humidityLabel.text = "Humidity: \(model.humidity)%"
        self.cloudsLabel.text = "Cloudiness: \(model.clouds)%"
        self.pressureLabel.text = "Pressure: \(model.pressure) hPa"
        self.windSpeedLabel.text = "Wind speed:\(model.wind_speed) m/s"
        
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
    
    func flipCell() {
        if viewFlipped {
            viewFlipped.toggle()
            UIView.transition(with: contentView, duration: 0.6, options: .transitionFlipFromTop) {
                self.contentView.insertSubview(self.normalView, aboveSubview: self.flipView)
            } completion: { _ in
            }
        } else {
            viewFlipped.toggle()
            UIView.transition(with: contentView, duration: 0.6, options: .transitionFlipFromBottom) {
                self.contentView.insertSubview(self.flipView, aboveSubview: self.normalView)
            } completion: { _ in
            }
        }
    }
}
