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
    
    var todayContainer: WWTodayContainer?
    
    var viewModel: WWMainViewModel {
        didSet {
            loadViewIfNeeded()
            bindViewModel()
        }
    }
    
    // MARK: - Private properties
    
    private var weeklyForecast: SevenDayWeatherForecastModel? {
        didSet {
            DispatchQueue.main.async {
                self.mainTable.reloadData()
            }
        }
    }
    
    private var hourlyTemperature: HourlyTemperatureModel? {
        didSet {
            DispatchQueue.main.async {
                self.hourlyPillsCollection.reloadData()
            }
        }
    }
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        self.viewModel = WWMainViewModel()
        
        super.init(coder: coder)
        
        bindViewModel()
    }
    
    // MARK: - Lifacycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Segue related methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedTodayOverallViewController" {
            todayContainer = segue.destination as? WWTodayContainer
        }
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
                
            case .didUpdateTodayOverallForecast(let forecast):
                self?.todayContainer?.update(with: forecast)
                
            case .didUpdateHourlyTemperature(let temperature):
                self?.hourlyTemperature = temperature
            }
        }
    }
    
    private func setupSubviews() {
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.layer.cornerRadius = 12
        locationLabel.text = "Текущая геолокация"
        hourlyPillsCollection.dataSource = self
    }
}

extension WWMainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyForecast?.time.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as? WWWeatherCellTableViewCell,
              let weeklyForecast = self.weeklyForecast else {
            return UITableViewCell()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        
        cell.dateLabel.text = dateFormatter.string(from: weeklyForecast.time[indexPath.row])
        cell.maxTemperatureLabel.text = String(format: "%.1f", weeklyForecast.maxTemperature[indexPath.row]) + "°"
        cell.minTemperatureLabel.text = String(format: "%.1f", weeklyForecast.minTemperature[indexPath.row]) + "°  -"
        cell.overallConditionLabel.text = WMODecoder.decodeWMOcode(weeklyForecast.weatherCode[indexPath.row], isDay: true)?.description
        cell.precipitationLabel.text = String(weeklyForecast.maxPrecipitationProbabily[indexPath.row]) + "%"
        cell.overallPicture.image = WMODecoder.decodeWMOcode(weeklyForecast.weatherCode[indexPath.row], isDay: true)?.image
        
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
        hourlyTemperature?.time.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyPill", for: indexPath) as? WWHourlyPillCollectionViewCell,
              let hourlyTemperature = self.hourlyTemperature
        else {
            return UICollectionViewCell()
        }
        
        cell.update(with: hourlyTemperature, at: indexPath)
      
        return cell
    }
    
    
}

