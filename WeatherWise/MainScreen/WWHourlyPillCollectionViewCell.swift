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
    
    func update(with hourlyTemperature: HourlyTemperature, at indexPath: IndexPath) {
        let time = hourlyTemperature.hourly.time[indexPath.row].components(separatedBy: "T")[1]
        let hour = time.components(separatedBy: ":")[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(identifier: hourlyTemperature.timezone)
        let currentHour = dateFormatter.string(from: Date())
        
        if hour == currentHour {
            self.pillView.backgroundColor = UIColor(named: "BaseBlue")
            self.tempLabel.textColor = UIColor.white
            self.timeLabel.textColor = UIColor.white

        }
        
        let littleImageName = decodeWMOcode(hourlyTemperature.hourly.weathercode[indexPath.row], isDay: true)[1]
        
        self.tempLabel.text = String(format: "%.1f", hourlyTemperature.hourly.temperature2M[indexPath.row]) + "°"
        self.timeLabel.text = time
        self.littleImage.image = UIImage(named: littleImageName)
    }
    
    private func setupSubviews() {
        pillView.layer.cornerRadius = pillView.frame.width / 2
        pillView.layer.borderColor = UIColor(named: "BaseBlue")?.cgColor
        pillView.layer.borderWidth = 1
    }
}
