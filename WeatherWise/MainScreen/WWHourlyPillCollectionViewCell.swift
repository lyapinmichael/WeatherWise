//
//  WWHourlyPillCollectionViewCell.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 19.07.2023.
//

import UIKit

class WWHourlyPillCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var pillView: UIView!
    @IBOutlet weak var littleImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var isNow = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
    }
    
    override func prepareForReuse() {
      
            self.pillView.backgroundColor = UIColor.white
            self.tempLabel.textColor = UIColor(named: "BaseBlue")
            self.timeLabel.textColor = UIColor(named: "BaseBlue")
      
    }
    
    func update(with hourlyTemperature: HourlyTemperatureModel, at indexPath: IndexPath) {
        let time = hourlyTemperature.time[indexPath.row]
//        let hour = time.components(separatedBy: ":")[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(identifier: hourlyTemperature.timezone)
        
        let timeString = dateFormatter.string(from: time)
        let currentHour = dateFormatter.string(from: Date())
        
        if timeString == currentHour {
            self.pillView.backgroundColor = UIColor(named: "BaseBlue")
            self.tempLabel.textColor = UIColor.white
            self.timeLabel.textColor = UIColor.white

        }
        
        let WMOCode = hourlyTemperature.weathercode[indexPath.row]
        
        self.tempLabel.text = String(format: "%.1f", hourlyTemperature.temperature[indexPath.row]) + "°"
        self.timeLabel.text = timeString + ":00"
        self.littleImage.image = WMODecoder.decodeWMOcode(WMOCode, isDay: true)?.image
    }
    
    private func setupSubviews() {
        pillView.layer.cornerRadius = pillView.frame.width / 2
        pillView.layer.borderColor = UIColor(named: "BaseBlue")?.cgColor
        pillView.layer.borderWidth = 1
    }
}
