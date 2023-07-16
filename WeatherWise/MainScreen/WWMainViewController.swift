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
    
    // MARK: - Private properties
    
    private let viewModel = WWMainViewModel()
    
    private var weeklyForecast: SevenDayWeahterForecast? {
        didSet {
            DispatchQueue.main.async {
                self.mainTable.reloadData()
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
            }
        }
    }
    
    private func setupSubviews() {
        mainTable.delegate = self
        mainTable.dataSource = self
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
        cell.overallConditionLabel.text = viewModel.decodeWMOcode(weeklyForecast.daily.weathercode[indexPath.row], isDay: true)[0]
        cell.humidityLabel.text = String(weeklyForecast.daily.precipitationProbabilityMax[indexPath.row]) + "%"
        cell.overallPicture.image = UIImage(named: viewModel.decodeWMOcode(weeklyForecast.daily.weathercode[indexPath.row], isDay: true)[1])
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
}

