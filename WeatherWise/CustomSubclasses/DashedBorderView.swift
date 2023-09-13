//
//  UIView+DashedLine.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 12.09.2023.
//

import Foundation
import UIKit

final class DashedBorderView: UIView {
    
    override func draw(_ rect: CGRect) {
        addDashedBorder()
    }
    
    func addDashedBorder() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [8,8]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
