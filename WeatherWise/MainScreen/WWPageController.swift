//
//  TopPageControllerViewController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 09.07.2023.
//

import UIKit

final class WWPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        guard let page1 = storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
        guard let page2 = storyboard?.instantiateViewController(withIdentifier: "AddNewLocation") else { return }
        
        pages.append(page1)
        pages.append(page2)
        
        setViewControllers([page1], direction: .forward, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if !UserDefaults.standard.bool(forKey: "isOnboardingPassed") {
            performSegue(withIdentifier: "presentOnboarding", sender: self)
        }
        
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let cur = pages.firstIndex(of: viewController)!

        if cur == 0 { return nil }
        
        var prev = (cur - 1) % pages.count
        if prev < 0 {
            prev = pages.count - 1
        }
        return pages[prev]
        
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let cur = pages.firstIndex(of: viewController)!
        
        if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)
        return pages[nxt]
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

}
