//
//  SettingsViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 25.08.2023.
//

import UIKit

enum WWSettingsNotification {
    
    static let unitsUpdated  = Notification.Name("unitsUpdated")
}

class WWSettingsViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var temperatureControl: UISegmentedControl!
    @IBOutlet weak var speedControl: UISegmentedControl!
    @IBOutlet weak var timeControl: UISegmentedControl!
    @IBOutlet weak var notificationControl: UISegmentedControl!
    
    // MARK: - Actions
    
    @IBAction func toggleTemperatureControl(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "temperatureUnit")
    }
    
    @IBAction func toggleSpeedControl(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "speedUnit")
    }
    
    @IBAction func toggleTimeControl(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "timeFormat")
    }
    
    @IBAction func toggleNotificationControl(_ sender: UISegmentedControl) {
        sender.selectedSegmentIndex == 0 ? print("Notifications ON") : print("Notifications OFF")
        
    }
    @IBAction func saveSettings(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: WWSettingsNotification.unitsUpdated, object: nil)
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 20
        
        setupSegmentControls()
        
    }

    func setupSegmentControls() {
        temperatureControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        temperatureControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "temperatureUnit")
        
        speedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        speedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "speedUnit")
        
        timeControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        timeControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "timeFormat")
        
        notificationControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
}
