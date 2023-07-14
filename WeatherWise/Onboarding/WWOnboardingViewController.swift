//
//  WWOnboardingViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 05.07.2023.
//

import UIKit

class WWOnboardingViewController: UIViewController {

    // MARK: - IBActionos
    
    @IBAction func useLocation(_ sender: Any) {
        self.locationService?.getPermission()
        
    }
    
    @IBAction func chooseLocationManually(_ sender: Any) {
        self.proceedToMainScreen()
    }
    
    private var locationService: WWLocationService?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.locationService = WWLocationService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Set location auth status to:", locationService?.authorizationStatus?.rawValue ?? "Bad status")
        NotificationCenter.default.addObserver(self, selector: #selector(proceedToMainScreen(_:)), name: WWCLNotifications.permissionGranted, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.locationService = nil
    }
    
    // MARK: - ObjC methods
    
    @objc private func proceedToMainScreen(_ notification: Notification? = nil) {
        if let notification = notification {
            print(notification.userInfo ?? "Bad status")
        }
        UserDefaults.standard.set(true, forKey: "isOnboardingPassed")
        self.dismiss(animated: true)
        
    }
}
