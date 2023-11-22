//
//  WWDetailedForecastViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 06.09.2023.
//

import UIKit

class WWDetailedForecastViewController: UIViewController {

    
    @IBOutlet weak var localityLabel: UILabel!
    
    @IBOutlet weak var detailedForecastTable: UITableView!
    
    private var detailedForecast: HourlyForecastModel? {
        didSet {
            if isViewLoaded {
                detailedForecastTable.reloadData()
            }
        }
    }
    private var locality: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailedForecastTable.dataSource = self
        detailedForecastTable.delegate = self
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailedForecastTable.reloadData()
        localityLabel.text = locality
    }
    
    // MARK: - Public methods
    
    func update(_ locality: String?, with detailedForecast: HourlyForecastModel) {
        self.detailedForecast = detailedForecast
        self.locality = locality
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Прогноз на 24 часа"
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
}

extension WWDetailedForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailedForecast?.time.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailedForecastCell") as? WWDetailedForecastTableViewCell  else {
            return UITableViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E dd/MM"
        let dateString = dateFormatter.string(from: Date())
        
        let wmoCode = detailedForecast?.weathercode[indexPath.row] ?? 0
        let wmoCodeDecoded = WMODecoder.decodeWMOcode(wmoCode, isDay: true)
        
        cell.WMOcodeDescriptionLabel.text = wmoCodeDecoded?.description ?? ""
        cell.WMOcodeImage.image = wmoCodeDecoded?.image 
        cell.dateLabel.text = dateString
        cell.hourLabel.text = detailedForecast?.time[indexPath.row]
        cell.precipitationProbabilityLabel.text = "\(detailedForecast?.precipitationProbability[indexPath.row] ?? 0)%"
        cell.windSpeedLabel.text = "\(detailedForecast?.windspeed[indexPath.row] ?? 0)"
        cell.speedUnitLabel.text = detailedForecast?.speedUnit ?? ""
        cell.windDirectionLabel.text = detailedForecast?.windDirection[indexPath.row] ?? ""
        cell.cloudcoverLabel.text = "\(detailedForecast?.cloudcover[indexPath.row] ?? 0)%"
        cell.temperatureLabel.text = "\(detailedForecast?.temperature[indexPath.row] ?? 0)º"
        
        return cell
    }
}

extension WWDetailedForecastViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        145
    }
    
}
