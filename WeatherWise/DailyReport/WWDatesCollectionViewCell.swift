//
//  WWDailyReportCollectionViewCell.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 10.09.2023.
//

import UIKit

final class WWDatesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var date: Date = Date() {
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM EEE"
            
            let dateString = dateFormatter.string(from: date)
            
            dateLabel.text = dateString
        }
    }
    
    // MARK: - Overrided properties
    
    override var isSelected: Bool {
        didSet {
            toggleDateSelection(isSelected)
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        containerView.frame = contentView.frame
    }
    
    override func prepareForReuse() {
        toggleDateSelection(false)
    }
    
    // MARK: - Public methods
    
    func setupSubviews() {
        containerView.layer.cornerRadius = 10
        
    }
    
    // MARK: Private methods
    
    private func toggleDateSelection(_ isDateSelected: Bool) {
        
        if isDateSelected {
            self.containerView.backgroundColor = UIColor(named: "BaseBlue")
            self.dateLabel.textColor = .white
        } else { 
            self.containerView.backgroundColor = .clear
            self.dateLabel.textColor = .black
        }
    }
}
