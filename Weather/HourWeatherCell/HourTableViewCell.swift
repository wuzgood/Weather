//
//  HourTableViewCell.swift
//  Weather
//
//  Created by Wuz Good on 20.08.2021.
//

import UIKit

class HourTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HourTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "HourTableViewCell", bundle: nil)
    }
}
