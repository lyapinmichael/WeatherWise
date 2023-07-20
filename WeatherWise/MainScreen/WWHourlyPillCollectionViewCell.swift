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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        pillView.layer.cornerRadius = pillView.frame.width / 2
        pillView.layer.borderColor = UIColor(named: "BaseBlue")?.cgColor
        pillView.layer.borderWidth = 1
    }
}
