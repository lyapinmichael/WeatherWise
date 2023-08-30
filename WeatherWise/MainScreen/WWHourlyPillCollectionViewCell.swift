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
        self.layer.shadowOpacity = 0
        
    }
    
    func update(with hourlyTemperature: HourlyTemperatureModel, at indexPath: IndexPath) {
        let time = hourlyTemperature.time[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = hourlyTemperature.timeFormat
        let currentHour = dateFormatter.string(from: Date())
        
        if time == currentHour {
            self.pillView.backgroundColor = UIColor(named: "BaseBlue")
            self.tempLabel.textColor = UIColor.white
            self.timeLabel.textColor = UIColor.white
            
            layer.shadowColor = UIColor(named: "BaseBlue")?.cgColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
            
            layer.masksToBounds = false

        }
        
        let WMOCode = hourlyTemperature.weathercode[indexPath.row]
        
        self.tempLabel.text = String(format: "%.1f", hourlyTemperature.temperature[indexPath.row]) + "°"
        self.timeLabel.text = time
        self.littleImage.image = WMODecoder.decodeWMOcode(WMOCode, isDay: true)?.image
    }
    
    private func setupSubviews() {
        pillView.layer.cornerRadius = pillView.frame.width / 2
        pillView.layer.borderColor = UIColor(named: "BaseBlue")?.cgColor
        pillView.layer.borderWidth = 1
    }
}
