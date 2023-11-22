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
    
    // MARK: - Overrided properties
    
    override var isSelected: Bool {
       didSet {
           toggleSelection(isSelected)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
    }

    // MARK: - Public methods
    
    func update(with hourlyTemperature: HourlyForecastModel, at indexPath: IndexPath) {
        let time = hourlyTemperature.time[indexPath.row]
        
        let WMOCode = hourlyTemperature.weathercode[indexPath.row]
        
        self.tempLabel.text = String(format: "%.1f", hourlyTemperature.temperature[indexPath.row]) + "°"
        self.timeLabel.text = time
        self.littleImage.image = WMODecoder.decodeWMOcode(WMOCode, isDay: true)?.image
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        pillView.layer.cornerRadius = pillView.frame.width / 2
        pillView.layer.borderColor = UIColor(named: "BaseBlue")?.cgColor
        pillView.layer.borderWidth = 1
    }
    
    private func toggleSelection(_ isSelected: Bool) {
       
        if isSelected {
            self.pillView.backgroundColor = UIColor(named: "BaseBlue")
            self.tempLabel.textColor = UIColor.white
            self.timeLabel.textColor = UIColor.white
            
            layer.shadowColor = UIColor(named: "BaseBlue")?.cgColor
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
            
            layer.masksToBounds = false
        } else {
            self.pillView.backgroundColor = UIColor.white
            self.tempLabel.textColor = UIColor(named: "BaseBlue")
            self.timeLabel.textColor = UIColor(named: "BaseBlue")
            
            self.layer.shadowOpacity = 0
        }
       
    }
}
