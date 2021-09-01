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
    
    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with model: ViewController.HourlyWeather) {
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
        
        // TODO: - Исправить размеры iconImageView
        self.tempLabel.text = "\(model.temp)"
        guard let weatherIcon = model.weather.first?.main else { return }
        self.iconImageView.image = UIImage(named: weatherIcon)?.withTintColor(dynamicColor)
        self.iconImageView.contentMode = .scaleAspectFit
    }

}
