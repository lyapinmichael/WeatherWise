//
//  PageFactory.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 22.07.2023.
//

import Foundation
import UIKit
import CoreLocation.CLLocation

final class WWPageFactory {
    
    var storyboard: UIStoryboard
    
    typealias pageCreationHandler = (UIViewController) -> Void
    
    enum PageType {
        case mainPageWithLocationDetected
        case mainPageWithLocationPreselected(location: CLLocation)
        case addNewLocationPage
        
        var viewControllerID: String {
            switch self {
            case .mainPageWithLocationDetected, .mainPageWithLocationPreselected:
                return "MainViewController"
            case .addNewLocationPage:
                return "AddNewLocation"
            }
        }
    }
    
    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }
    
    func makePage(ofType type: PageType, handler: @escaping pageCreationHandler ) {
        
        switch type {
        case .addNewLocationPage, .mainPageWithLocationDetected:
            handler(storyboard.instantiateViewController(withIdentifier: type.viewControllerID))
        case .mainPageWithLocationPreselected(let location):
            let viewController = storyboard.instantiateViewController(withIdentifier: type.viewControllerID)
            let viewModel = WWMainViewModel()
            (viewController as? WWMainViewController)?.viewModel = viewModel
            (viewController as? WWMainViewController)?.viewModel.updateLocation(with: location)
            handler(viewController)
            
        }
        
        
    }
}

