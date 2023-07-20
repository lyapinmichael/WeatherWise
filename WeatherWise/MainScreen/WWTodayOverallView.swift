//
//  WWTodayOverallView.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 17.07.2023.
//

import UIKit

final class WWTodayOverallViewController: UIViewController{

    @IBOutlet weak var minMaxTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var overallConditionLabel: UILabel!
    @IBOutlet weak var dawnTimeLabel: UILabel!
    @IBOutlet weak var duskTimeLabel: UILabel!
    @IBOutlet weak var UVfactorLabel: UILabel!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(update(with:)), name: WWNSNotifications.dailyOverallForecastReceived, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isUpdated {
            startShimmerAnimation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    private func setupSubviews() {
        backgroundView.layer.cornerRadius = 12
        dawnImage.image = dawnImage.image?.withTintColor(UIColor(named: "SunnyYellow") ?? UIColor.systemYellow, renderingMode: .alwaysTemplate)
        duskImage.image = duskImage.image?.withTintColor(UIColor(named: "SunnyYellow") ?? UIColor.systemYellow, renderingMode: .alwaysTemplate)
        
    }
    
    @objc private func update(with notification: Notification? = nil) {
        guard let notification = notification,
              let userInfo = notification.userInfo else {
            print("Bad Notification")
            return
        }
        
        guard let dailyOverallForecast = userInfo["dailyOverallForecast"] as? DailyOverallForecast else {
            print("Failed to cast received userInfo to DailyOverallForecast")
            return
        }
        
        let today = Date()
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "H:mm, EEE dd MMMM"
        todayFormatter.timeZone = TimeZone(identifier: dailyOverallForecast.timezone)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        
        let roughHourFormatter = DateFormatter()
        roughHourFormatter.dateFormat = "H"
        
        let dawnTime = dailyOverallForecast.daily.sunrise[0].components(separatedBy: "T")[1]
        let duskTime = dailyOverallForecast.daily.sunset[0].components(separatedBy: "T")[1]
        
        let hourIndex = Int(roughHourFormatter.string(from: today)) ?? 11
        let currentTemperature = dailyOverallForecast.hourly.temperature2M[hourIndex]
        let currentWindspeed = dailyOverallForecast.hourly.windspeed10M[hourIndex]
        let currentOverallCondition = decodeWMOcode(dailyOverallForecast.hourly.weathercode[hourIndex], isDay: true)[0]
        
        minMaxTempLabel.text = "\(dailyOverallForecast.daily.temperature2MMin[0])°/\(dailyOverallForecast.daily.temperature2MMax[0])°"
        print(dailyOverallForecast.daily.temperature2MMin[0])
        print(dailyOverallForecast.daily.temperature2MMax[0])
        currentTempLabel.text = "\(currentTemperature)°"
        dawnTimeLabel.text = dawnTime
        duskTimeLabel.text = duskTime
        todayLabel.text = todayFormatter.string(from: today)
        overallConditionLabel.text = currentOverallCondition
        windspeedLabel.text = "\(currentWindspeed) м/с"
        precipitationProbabilityLabel.text = "\(dailyOverallForecast.daily.precipitationProbabilityMax[0]) %"
        UVfactorLabel.text = "\(dailyOverallForecast.daily.uvIndexMax[0])"
        gradientLayer.removeFromSuperlayer()

        isUpdated = true
        stopShimmerAnimation()
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
        let animDuration: CFTimeInterval = 1.0
        
        let anim1 = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor(named: "LighterBlue")?.cgColor
        anim1.toValue = UIColor(named: "BaseBlue")?.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation (keyPath:
        #keyPath (CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor(named: "BaseBlue")?.cgColor
        anim2.toValue = UIColor(named: "LighterBlue")?.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration
        
        let group = CAAnimationGroup ()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        return group
    }

}
