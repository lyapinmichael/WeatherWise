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
        case mainPageWithNewLocation(location: DecodedLocation)
        case mainPageWithSavedLocation(location: DecodedLocation)
        case addNewLocationPage
        
        var viewControllerID: String {
            switch self {
            case .mainPageWithLocationDetected, .mainPageWithNewLocation, .mainPageWithSavedLocation:
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
        
        let viewController = storyboard.instantiateViewController(withIdentifier: type.viewControllerID)
        
        switch type {
        case .addNewLocationPage, .mainPageWithLocationDetected:
            if viewController is WWMainViewController {
                let viewModel = WWMainViewModel(.mainPageWithLocationDetected)
                (viewController as? WWMainViewController)?.viewModel = viewModel
            }
            handler(viewController)
        case .mainPageWithNewLocation(let location):
            guard let mainViewContoller = viewController as? WWMainViewController else { return }
            let viewModel = WWMainViewModel(type)
            mainViewContoller.viewModel = viewModel
            mainViewContoller.viewModel.updateLocation(with: location)
            handler(mainViewContoller)
        case .mainPageWithSavedLocation(let location):
            guard let mainViewContoller = viewController as? WWMainViewController else { return }
            let viewModel = WWMainViewModel(type)
            mainViewContoller.viewModel = viewModel
            mainViewContoller.viewModel.updateLocation(with: location)
            handler(mainViewContoller)
            
        }
        
        
    }
}

