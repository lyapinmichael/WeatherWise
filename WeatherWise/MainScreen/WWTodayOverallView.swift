//
//  WWTodayOverallView.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 17.07.2023.
//

import UIKit

protocol WWTodayContainer {
    
    func update(with dailyOverallForecast: DailyOverallForecastModel)
    
}

final class WWTodayOverallViewController: UIViewController{

    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var overallConditionLabel: UILabel!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var UVindexLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var precipitationProbabilityLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var duskImage: UIImageView!
    @IBOutlet weak var dawnImage: UIImageView!
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1, y: 0.5)
        gradientLayer.cornerRadius = backgroundView.layer.cornerRadius
        gradientLayer.frame = backgroundView.bounds
        
        return gradientLayer
    }()

    private var isUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isUpdated {
            startShimmerAnimation()
        }
    }
    
    private func setupSubviews() {
        backgroundView.layer.cornerRadius = 12
        dawnImage.image = dawnImage.image?.withTintColor(UIColor(named: "SunnyYellow") ?? UIColor.systemYellow, renderingMode: .alwaysTemplate)
        duskImage.image = duskImage.image?.withTintColor(UIColor(named: "SunnyYellow") ?? UIColor.systemYellow, renderingMode: .alwaysTemplate)
        
    }
    
    private func startShimmerAnimation() {
        
        backgroundView.layer.addSublayer(gradientLayer)
        
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        gradientLayer.add(animationGroup, forKey: "backgroundColor")

    }
    
    private func stopShimmerAnimation() {
        gradientLayer.removeFromSuperlayer()
    }
    
    private func makeAnimationGroup() -> CAAnimationGroup {
        let animationDuration: CFTimeInterval = 1.0
        
        let animationOne = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        animationOne.fromValue = UIColor(named: "LighterBlue")?.cgColor
        animationOne.toValue = UIColor(named: "BaseBlue")?.cgColor
        animationOne.duration = animationDuration
        animationOne.beginTime = 0.0
        
        let animationTwo = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        animationTwo.fromValue = UIColor(named: "BaseBlue")?.cgColor
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

extension WWTodayOverallViewController: WWTodayContainer {
    func update(with dailyOverallForecast: DailyOverallForecastModel) {
        let today = Date()
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "H:mm, EEE dd MMMM"
        todayFormatter.timeZone = dailyOverallForecast.timezone
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        
        let roughHourFormatter = DateFormatter()
        roughHourFormatter.dateFormat = "H"
        
        let sunriseTime = dailyOverallForecast.sunrise
        let sunsetTime = dailyOverallForecast.sunset
        
        let hourIndex = Int(roughHourFormatter.string(from: today)) ?? 11
        let currentTemperature = dailyOverallForecast.hourlyTemperature[hourIndex]
        let currentWindspeed = dailyOverallForecast.hourlyTemperature[hourIndex]
        let currentOverallCondition = WMODecoder.decodeWMOcode(dailyOverallForecast.hourlyWeatherCode[hourIndex], isDay: true)?.description
        
        minMaxTempLabel.text = "\(dailyOverallForecast.minTemperature)°/\(dailyOverallForecast.maxTemperature)°"
        currentTempLabel.text = "\(currentTemperature)°"
        sunriseTimeLabel.text = timeFormatter.string(from: sunriseTime)
        sunsetTimeLabel.text = timeFormatter.string(from: sunsetTime)
        todayLabel.text = todayFormatter.string(from: today)
        overallConditionLabel.text = currentOverallCondition
        windspeedLabel.text = "\(currentWindspeed) м/с"
        precipitationProbabilityLabel.text = "\(dailyOverallForecast.maxPrecipitationProbability) %"
        UVindexLabel.text = "\(dailyOverallForecast.maxUVindex)"
        gradientLayer.removeFromSuperlayer()

        isUpdated = true
        stopShimmerAnimation()
    }
}
