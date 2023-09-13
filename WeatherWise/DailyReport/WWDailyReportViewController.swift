//
//  WWDailyReportViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 08.09.2023.
//

import UIKit

class WWDailyReportViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var dailyReportocalityLabel: UILabel!
    
    @IBOutlet weak var datesCollection: UICollectionView!
    
    @IBOutlet weak var dayContainerView: UIView!
    
    @IBOutlet weak var dayWMODescriptionLabel: UILabel!
    @IBOutlet weak var dayWMOImage: UIImageView!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    @IBOutlet weak var dayApparentTemperatureLabel: UILabel!
    @IBOutlet weak var dayWindLabel: UILabel!
    @IBOutlet weak var dayUVIndexLabel: UILabel!
    @IBOutlet weak var dayPrecipitationLabel: UILabel!
    @IBOutlet weak var dayCloudCoverLabel: UILabel!
    
    @IBOutlet weak var nightContainerView: UIView!
    
    @IBOutlet weak var nightWMOImage: UIImageView!
    @IBOutlet weak var nightWMODescriptionLabel: UILabel!
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    @IBOutlet weak var nightApparentTemperatureLabel: UILabel!
    @IBOutlet weak var nightWindLabel: UILabel!
    @IBOutlet weak var nightUVIndexLabel: UILabel!
    @IBOutlet weak var nightPrecipitationLabel: UILabel!
    @IBOutlet weak var nightCloudCoverLabel: UILabel!
    
    @IBOutlet weak var solarDayLengthLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var airQualityLabel: UILabel!
    @IBOutlet weak var airQualityIndexLabel: UILabel!
    @IBOutlet weak var airQualitySummaryLabel: UILabel!
    @IBOutlet weak var airQualityDescriptionLabel: UILabel!
    
    // MARK: - Public properties
    
    var preselectedDateCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Private properties
    
    private var viewModel = WWDailyReportViewModel()
    
    private var locality: String?
    
    private var dates: [Date] = [] 
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSubviews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dailyReportocalityLabel.text = locality ?? ""
        self.datesCollection.reloadData()
        
        DispatchQueue.main.async {
            self.datesCollection.selectItem(at: self.preselectedDateCellIndexPath, animated: true, scrollPosition: .left)
        }
    }
    
    // MARK: - Public methods
    
    func update(_ locality: String?, coordinates: WWMainViewModel.CurrentLocation?, dates: [Date]) {
        self.locality = locality
        self.dates = dates
        
        if let coordinates = coordinates {
            viewModel.updateState(with: .requestDailyReport(coordinates, dates[preselectedDateCellIndexPath.row]))

        }
    }

    // MARK: - Private methods
    
    private func setupNavigationBar() {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Дневная погода"
        configuration.titleAlignment = .trailing
        configuration.image = UIImage(named: "BackArrow")?.withTintColor(UIColor.systemGray)
        configuration.imagePadding = 10
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = UIColor.systemGray3
        configuration.baseBackgroundColor = UIColor.systemGray3
        
        let pushBack = UIAction(handler: { [weak self] _ in
            
            self?.navigationController?.popViewController(animated: true)
            
        })
        
        let button = UIButton(configuration: configuration, primaryAction: pushBack)
        
        let backBarButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = backBarButton
    
    }
    
    private func setupSubviews() {
        datesCollection.dataSource = self
        datesCollection.delegate = self
        datesCollection.showsHorizontalScrollIndicator = false
        
        dayContainerView.layoutIfNeeded()
        nightContainerView.layoutIfNeeded()
        airQualitySummaryLabel.layoutIfNeeded()
        
        dayContainerView.layer.masksToBounds = true
        nightContainerView.layer.masksToBounds = true
        airQualitySummaryLabel.layer.masksToBounds = true
        
        dayContainerView.layer.cornerRadius = 12
        nightContainerView.layer.cornerRadius = 12
        airQualitySummaryLabel.layer.cornerRadius = 8

    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            switch state {
            case .inital:
                return
                
            case .didReceiveDailyDetailedReport(let report):
                DispatchQueue.main.async {
                    self?.update(with: report)
                }
                
            case .didReceiveAirQualityIndex(let airQualityIndex):
                DispatchQueue.main.async {
                    self?.update(with: airQualityIndex)
                }
                
            case .failedToGetAirQuality:
                self?.hideAirQuality()
            }
        }
    }
    
    private func update(with report: DailyDetailedReportModel) {
        
        dayTemperatureLabel.text = String(format: "%.1f", report.maxTemperatureDay) + "º"
        dayApparentTemperatureLabel.text = String(format: "%.1f", report.maxApparentTemperatureDay) + "º"
        dayWindLabel.text = String(format: "%.1f",report.maxWindSpeedDate) + " " + report.speedUnit + " " + report.dominantWindDirectionDay
        dayPrecipitationLabel.text = "\(report.maxPrecipitationProbabilityDay) %"
        dayCloudCoverLabel.text = String(format: "%.1f", report.averageCloudCoverDay) + " %"
        dayUVIndexLabel.text = "\(report.maxUVIndexDay)"
        
        let wmoDecodedDay = WMODecoder.decodeWMOcode(report.dominantWeatherCodeDay, isDay: true)
        dayWMOImage.image = wmoDecodedDay?.image
        dayWMODescriptionLabel.text = wmoDecodedDay?.description ?? ""
        
        nightTemperatureLabel.text = String(format: "%.1f", report.maxTemperatureNight) + "º"
        nightApparentTemperatureLabel.text = String(format: "%.1f", report.maxTemperatureNight) + "º"
        nightWindLabel.text = String(format: "%.1f",report.maxWindSpeedNight) + " " + report.speedUnit + " " + report.domninantWindDirectionNight
        nightPrecipitationLabel.text = "\(report.maxPrecipitationProbabilityNight) %"
        nightCloudCoverLabel.text = String(format: "%.1f", report.averageCloudCoverNight) + "%"
        nightUVIndexLabel.text = "\(report.maxUVIndexNight)"
        
        let wmoDecodedNight = WMODecoder.decodeWMOcode(report.dominantWeatherCodeNight, isDay: false)
        nightWMOImage.image = wmoDecodedNight?.image
        nightWMODescriptionLabel.text = wmoDecodedNight?.description ?? ""
        
        sunriseLabel.text = report.sunrise
        sunsetLabel.text = report.sunset
        solarDayLengthLabel.text = report.solarDayLenght
        
    }
    
    private func update(with airQualityIndex: AirQualityIndexModel) {
        airQualityIndexLabel.text = "\(airQualityIndex.averageHourlyIndex)"
        
        let airQuality = airQualityIndex.airQuality
        airQualitySummaryLabel.text = airQuality.summary
        airQualitySummaryLabel.backgroundColor = airQuality.color
        airQualityDescriptionLabel.text = airQuality.description
        
    }
    
    private func hideAirQuality() {
        airQualityLabel.isHidden = true
        airQualitySummaryLabel.isHidden = true
        airQualityIndexLabel.isHidden = true
        airQualityDescriptionLabel.isHidden = true
        
    }
}

// MARK: - Collection view datasource extesion

extension WWDailyReportViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datesCell", for: indexPath) as? WWDatesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.date = dates[indexPath.row]
        
        return cell
    }
}

extension WWDailyReportViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WWDatesCollectionViewCell else { return }
        
        viewModel.updateState(with: .updateReport(cell.date))
    }
}
