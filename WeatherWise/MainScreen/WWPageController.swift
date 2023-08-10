//
//  TopPageControllerViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 09.07.2023.
//

import UIKit
import CoreLocation.CLLocation

final class WWPageController: UIPageViewController {
    
    var pageFactory: WWPageFactory?
    
    var pages: [UIViewController] = [] {
        didSet {
            setViewControllers([pages[0]], direction: .forward, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        bindFactory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if case .authorizedWhenInUse = WWLocationService.shared.authorizationStatus {
            pageFactory?.makePage(ofType: .mainPageWithLocationDetected, handler: { [weak self] viewController in
                self?.pages.insert(viewController, at: 0)
            })
            WWLocationService.shared.requestLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "isOnboardingPassed") {
            performSegue(withIdentifier: "presentOnboarding", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentOnboarding" {
            (segue.destination as? WWOnboardingViewController)?.delegate = self
        }
    }
    
    private func bindFactory() {
        pageFactory = WWPageFactory(storyboard: self.storyboard!)
        pageFactory?.makePage(ofType: .addNewLocationPage, handler: { [weak self] viewController in
            (viewController as? WWAddNewLocationController)?.delegate = self
            self?.pages.append(viewController)
        })
    }
    
}

extension WWPageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let current = pages.firstIndex(of: viewController)!

        if current == 0 { return nil }
        
        var previous = (current - 1) % pages.count
        if previous < 0 {
            previous = pages.count - 1
        }
        return pages[previous]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let current = pages.firstIndex(of: viewController)!
        
        if current == (pages.count - 1) { return nil }
        
        let next = abs((current + 1) % pages.count)
        return pages[next]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
}

extension WWPageController: WWOnboardingDelegate {
    func onboarding(withPermission permission: Bool) {
        if permission {
            pageFactory?.makePage(ofType: .mainPageWithLocationDetected, handler: { [weak self] viewController in
                self?.pages.insert(viewController, at: 0)
            })
        }
    }
}

extension WWPageController: WWNewLocationDelegate {
    func newLocation(didAdd location: CLLocation) {
        pageFactory?.makePage(ofType: .mainPageWithLocationPreselected(location: location), handler: { [weak self] viewController in
            guard let self = self else {
                return
            }
            self.pages.insert(viewController, at: self.pages.count - 1)
        })
    }
    
    
}
