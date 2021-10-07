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
    
    func configure(with model: DailyWeather) {
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
        
        // front cell view (normalView)
        self.minTempLabel.text = "\(Int(model.temp.min))°"
        self.maxTempLabel.text = "\(Int(model.temp.max))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        guard let weatherIcon = model.weather.first?.main else { return }
        self.iconImageView.image = UIImage(named: weatherIcon)
//        self.iconImageView.image = UIImage(named: weatherIcon)?.withTintColor(dynamicColor)

        self.iconImageView.contentMode = .scaleAspectFit
        
        // back cell labels with SF symbols
        let humidityIcon = NSTextAttachment()
        humidityIcon.image = UIImage(systemName: "drop")
//        humidityIcon.image = UIImage(systemName: "drop")?.withTintColor(dynamicColor)

        let humidityString = NSMutableAttributedString(attachment: humidityIcon)
        humidityString.append(NSAttributedString(string: " Humidity: \(model.humidity)%"))
        
        let cloudsIcon = NSTextAttachment()
        cloudsIcon.image = UIImage(systemName: "cloud")
//        cloudsIcon.image = UIImage(systemName: "cloud")?.withTintColor(dynamicColor)

        let cloudsString = NSMutableAttributedString(attachment: cloudsIcon)
        cloudsString.append(NSAttributedString(string: " Cloudiness: \(model.clouds)%"))
        
        let pressureIcon = NSTextAttachment()
        pressureIcon.image = UIImage(systemName: "thermometer")
//        pressureIcon.image = UIImage(systemName: "thermometer")?.withTintColor(dynamicColor)

        let pressureString = NSMutableAttributedString(attachment: pressureIcon)
        pressureString.append(NSAttributedString(string: " Pressure: \(model.pressure) hPa"))
        
        let windIcon = NSTextAttachment()
        windIcon.image = UIImage(systemName: "wind")
//        windIcon.image = UIImage(systemName: "wind")?.withTintColor(dynamicColor)

        let windString = NSMutableAttributedString(attachment: windIcon)
        windString.append(NSAttributedString(string: " Wind speed:\(model.wind_speed) m/s"))
        
        // back cell view (flipView)
        self.humidityLabel.attributedText = humidityString
        self.cloudsLabel.attributedText = cloudsString
        self.pressureLabel.attributedText = pressureString
        self.windSpeedLabel.attributedText = windString
        
        flipView.isHidden = true
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let date = date else { return ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    func flipToNormalView() {
        viewFlipped.toggle()
        UIView.transition(with: contentView, duration: 0.6, options: .transitionFlipFromTop) {
//            self.isHidden.toggle()
            self.contentView.insertSubview(self.normalView, aboveSubview: self.flipView)
            self.normalView.isHidden = false
            self.flipView.isHidden = true
        } completion: { _ in
        }
    }
    
    func autoFlip() {
        if viewFlipped {
            flipToNormalView()
        } else {
            return
        }
    }
    
    func flipCell() {
        if viewFlipped {
            flipToNormalView()
        } else {
            viewFlipped.toggle()
            UIView.transition(with: contentView, duration: 0.6, options: .transitionFlipFromBottom) {
                self.contentView.insertSubview(self.flipView, aboveSubview: self.normalView)
                self.flipView.isHidden = false
                self.normalView.isHidden = true
            } completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                    self.autoFlip()
                }
            }
        }
    }
}
