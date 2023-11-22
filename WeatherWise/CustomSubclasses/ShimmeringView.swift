//
//  UIView+ShimmerAnimation.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 13.09.2023.
//

import Foundation
import UIKit

final class ShimmeringView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.frame = self.bounds
        
        return gradientLayer
        
    }()
    
    func startShimmerAnimation() {
      
        self.layer.addSublayer(gradientLayer)
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradientLayer.add(animationGroup, forKey: "backgroundColor")
    }
    
    func stopShimmerAnimation() {
        self.gradientLayer.removeFromSuperlayer()
    }
    
    private func makeAnimationGroup() -> CAAnimationGroup {
        let animationDuration: CFTimeInterval = 1.0
        
        let animationOne = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        animationOne.fromValue = UIColor(named: "LighterBlue")?.cgColor
        animationOne.toValue = UIColor(named: "EvenLighterBlue")?.cgColor
        animationOne.duration = animationDuration
        animationOne.beginTime = 0.0
        
        let animationTwo = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        animationTwo.fromValue = UIColor(named: "EvenLighterBlue")?.cgColor
        animationTwo.toValue = UIColor(named: "LighterBlue")?.cgColor
        animationTwo.duration = animationDuration
        animationTwo.beginTime = animationOne.beginTime + animationOne.duration
        
        let animationGroup = CAAnimationGroup ()
        animationGroup.animations = [animationOne, animationTwo]
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.duration = animationTwo.beginTime + animationOne.duration
        animationGroup.isRemovedOnCompletion = false
        
        return animationGroup
    }
}
