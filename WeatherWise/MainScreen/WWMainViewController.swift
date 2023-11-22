//
//  ViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 04.07.2023.
//

import UIKit

final class WWMainViewController: UIViewController {
   
    // MARK: - IBOutlets
    
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var mainTable: UITableView!
    
    @IBOutlet weak var hourlyPillsCollection: UICollectionView!
    
    @IBOutlet weak var locationPinButton: UIButton!
    
    @IBOutlet weak var pushToDetailedForecatScreen: UIButton!
    
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
    
    private var hourlyForecast: HourlyForecastModel? {
        didSet {
            DispatchQueue.main.async {
                self.hourlyPillsCollection.reloadData()
                self.selectCurrentHourPill()
            }
        }
    }
    
    private var localityString: String?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationPinButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.selectCurrentHourPill()
    }
    
    // MARK: - Segue related methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedTodayOverallViewController" {
            todayContainer = segue.destination as? WWTodayContainer
        }
        
        if segue.identifier == "pushToDetailedForecastView" {
            guard let detailedView = segue.destination as? WWDetailedForecastViewController,
                  let hourlyForecast = self.hourlyForecast else { return }
            detailedView.update(localityString, with: hourlyForecast)
        }
        
        if segue.identifier == "pushToDailyReportController" {
            guard let dailyReportController = segue.destination as? WWDailyReportViewController,
                  let senderCell = sender as? WWWeatherCellTableViewCell,
                  let weeklyForecast = self.weeklyForecast else { return }
           
            dailyReportController.update(localityString, coordinates: viewModel.currentLocation, dates: weeklyForecast.time)
            dailyReportController.preselectedDateCellIndexPath = senderCell.indexPath
          
        }
        
        if segue.identifier == "forcePresentOnboarding" {
            let pageController = self.parent as? WWPageController
            
            (segue.destination as? WWOnboardingViewController)?.delegate = pageController
            
        }
    }
    // MARK: - Private methods
    
    private func bindViewModel() {
        viewModel.delegate = self
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                print("initial state of viewModel")
                
            case .willUseGeolocation:
                self?.locationImage.isHidden = false
                
            case .didUpdateLocation(let location):
                DispatchQueue.main.async {
                    self?.locationLabel.text = location
                }
                self?.localityString = location
                
            case .didUpdateWeeklyWeatherForecast(let forecast):
                self?.weeklyForecast = forecast
                
            case .didUpdateTodayOverallForecast(let forecast):
                self?.todayContainer?.update(with: forecast)
                
            case .didUpdateHourlyTemperature(let temperature):
                self?.hourlyForecast = temperature
                self?.pushToDetailedForecatScreen.isEnabled = true
                
            case .reload:
                DispatchQueue.main.async {
                    self?.mainTable.reloadData()
                    self?.hourlyPillsCollection.reloadData()
                    self?.todayContainer?.reload()
                }
            
            case .didGetPermission:
                DispatchQueue.main.async {
                    self?.checkLocationPinButton()
                }
            }
        }
    }
    
    private func setupSubviews() {
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.layer.cornerRadius = 12
        mainTable.showsVerticalScrollIndicator = false
        
        locationLabel.text = "Текущая геолокация"
        
        hourlyPillsCollection.dataSource = self
        hourlyPillsCollection.showsHorizontalScrollIndicator = false

    }
    
    private func selectCurrentHourPill() {
        guard let hourlyForecast =  self.hourlyForecast else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = hourlyForecast.timeFormat
        let currentHour = dateFormatter.string(from: Date())
        
        guard let currentHourIndex = hourlyForecast.time.firstIndex(where: { $0 == currentHour }) else { return }
        
        self.hourlyPillsCollection.selectItem(at: IndexPath(row: currentHourIndex, section: 0), animated: true, scrollPosition: .left)
        
    }
    
    private func checkLocationPinButton() {
        if case .authorizedWhenInUse = WWLocationService.shared.authorizationStatus {
                self.locationPinButton.isHidden = true
        }
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
        
        cell.indexPath = indexPath
        
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
        hourlyForecast?.time.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyPill", for: indexPath) as? WWHourlyPillCollectionViewCell,
              let hourlyTemperature = self.hourlyForecast
        else {
            return UICollectionViewCell()
        }
        
        cell.update(with: hourlyTemperature, at: indexPath)
        cell.isUserInteractionEnabled = false
      
        return cell
    }
    
    
}

