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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update(with:)), name: WWNSNotifications.dailyOverallForecastReceived, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    private func setupSubviews() {
        backgroundView.layer.cornerRadius = 12
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
        
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "H:mm, EEE dd MMMM"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H:mm"
        
        let roughHourFormatter = DateFormatter()
        roughHourFormatter.dateFormat = "H"
        
        let dawnTime = ISO8601DateFormatter().date(from: dailyOverallForecast.daily.sunrise[0])
        let duskTime = ISO8601DateFormatter().date(from: dailyOverallForecast.daily.sunset[0])
        
        let today = Date()
        let hourIndex = Int(roughHourFormatter.string(from: today)) ?? 11
        let currentTemperature = dailyOverallForecast.hourly.temperature2M[hourIndex]
        let currentWindspeed = dailyOverallForecast.hourly.windspeed10M[hourIndex]
        let currentOverallCondition = decodeWMOcode(dailyOverallForecast.hourly.weathercode[hourIndex], isDay: true)[0]
        
        minMaxTempLabel.text = "\(dailyOverallForecast.daily.temperature2MMin[0])°/\(dailyOverallForecast.daily.temperature2MMax[0])°"
        print(dailyOverallForecast.daily.temperature2MMin[0])
        print(dailyOverallForecast.daily.temperature2MMax[0])
        currentTempLabel.text = "\(currentTemperature)°"
        dawnTimeLabel.text = timeFormatter.string(from: dawnTime ?? today)
        duskTimeLabel.text = timeFormatter.string(from: duskTime ?? today)
        todayLabel.text = todayFormatter.string(from: today)
        overallConditionLabel.text = currentOverallCondition
        windspeedLabel.text = "\(currentWindspeed) м/с"
        precipitationProbabilityLabel.text = "\(dailyOverallForecast.daily.precipitationProbabilityMax[0]) %"
        UVfactorLabel.text = "\(dailyOverallForecast.daily.uvIndexMax[0])"

    }

}
