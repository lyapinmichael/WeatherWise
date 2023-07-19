//
//  WWWeatherCellTableViewCell.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.07.2023.
//

import UIKit

class WWWeatherCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var overallConditionLabel: UILabel!
    @IBOutlet weak var overallPicture: UIImageView!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var weatherContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4))
        setupSubviews()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupSubviews() {
        weatherContentView.layer.cornerRadius = 12
    }

}
