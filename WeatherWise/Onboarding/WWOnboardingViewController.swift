//
//  WWOnboardingViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 05.07.2023.
//

import UIKit

protocol WWOnboardingDelegate: AnyObject {
    func onboarding(withPermission permission: Bool)
}

class WWOnboardingViewController: UIViewController {

    // MARK: - IBActionos
    
    @IBAction func useLocation(_ sender: Any) {
        WWLocationService.shared.getPermission()
        
    }
    
    @IBAction func chooseLocationManually(_ sender: Any) {
        self.proceedToMainScreen()
    }
    
    weak var delegate: WWOnboardingDelegate?
    private var locationService = WWLocationService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(proceedToMainScreen(_:)), name: WWCLNotifications.authorizationChanged, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - ObjC methods
    
    @objc private func proceedToMainScreen(_ notification: Notification? = nil) {
        
        let userInfo = notification?.userInfo as? [String: Bool]
        
        UserDefaults.standard.set(true, forKey: "isOnboardingPassed")
        delegate?.onboarding(withPermission: userInfo?["authStatus"] ?? false)
        self.dismiss(animated: true)
        
    }
}
