//
//  ViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 04.07.2023.
//

import UIKit

final class WWMainViewController: UIViewController {
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var hourlyPillsCollection: UICollectionView!
    // MARK: - Private properties
    
    private let viewModel = WWMainViewModel()
    
    private var weeklyForecast: SevenDayWeahterForecast? {
        didSet {
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }
    }
    
    private var hourlyTemperature: HourlyTemperature? {
        didSet {
            DispatchQueue.main.async {
                self.hourlyPillsCollection.reloadData()
            }
        }
    }
    
    // MARK: - Lifacycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bindViewModel()
        setupSubviews()
       
        locationLabel.text = WWLocationService.currentLocation?.coordinate.latitude.formatted()
        
    }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.delegate = self
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
            case .didUpdateLocation(let location):
                DispatchQueue.main.async {
                    self?.locationLabel.text = location
                }
            case .didUpdateWeeklyWeatherForecast(let forecast):
                self?.weeklyForecast = forecast
            case .didUpdateHourlyTemperature(let temperature):
                self?.hourlyTemperature = temperature
            }
        }
    }
    
    private func setupSubviews() {
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.layer.cornerRadius = 12
        
        hourlyPillsCollection.dataSource = self
    }
}

extension WWMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyForecast?.daily.time.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? WWWeatherCellTableViewCell,
              let weeklyForecast = self.weeklyForecast else {
            return UITableViewCell()
        }
        let dateSubstringArray = weeklyForecast.daily.time[indexPath.row].split(separator: "-")
        let month = dateSubstringArray[1]
        let day = dateSubstringArray[2]
        cell.dateLabel.text = "\(day)/\(month)"
        cell.maxTemperatureLabel.text = String(format: "%.1f", weeklyForecast.daily.temperature2MMax[indexPath.row]) + "°"
        cell.minTemperatureLabel.text = String(format: "%.1f", weeklyForecast.daily.temperature2MMin[indexPath.row]) + "°  -"
        cell.overallConditionLabel.text = decodeWMOcode(weeklyForecast.daily.weathercode[indexPath.row], isDay: true)[0]
        cell.precipitationLabel.text = String(weeklyForecast.daily.precipitationProbabilityMax[indexPath.row] ?? 0) + "%"
        cell.overallPicture.image = UIImage(named: decodeWMOcode(weeklyForecast.daily.weathercode[indexPath.row], isDay: true)[1])
        return cell
    }
}

extension WWMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ежедневный прогноз"
    }
}

extension WWMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyTemperature?.hourly.temperature2M.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyPill", for: indexPath) as? WWHourlyPillCollectionViewCell,
              let hourlyTemperature = self.hourlyTemperature
        else {
            return UICollectionViewCell()
        }
        
        let time = hourlyTemperature.hourly.time[indexPath.row].components(separatedBy: "T")[1]
        let hour = time.components(separatedBy: ":")[0]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.timeZone = TimeZone(identifier: hourlyTemperature.timezone)
        let currentHour = dateFormatter.string(from: Date())
        
        if hour == currentHour {
            cell.pillView.backgroundColor = UIColor(named: "BaseBlue")
            cell.tempLabel.textColor = UIColor.white
            cell.timeLabel.textColor = UIColor.white
        }
        
        let littleImageName = decodeWMOcode(hourlyTemperature.hourly.weathercode[indexPath.row], isDay: true)[1]
        
        cell.tempLabel.text = String(format: "%.1f", hourlyTemperature.hourly.temperature2M[indexPath.row]) + "°"
        cell.timeLabel.text = time
        cell.littleImage.image = UIImage(named: littleImageName)
        return cell
    }
    
    
}

