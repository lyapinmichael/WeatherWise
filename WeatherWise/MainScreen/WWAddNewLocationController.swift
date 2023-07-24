//
//  AddNewLocationController.swift
//  WeatherWise
//
//  Created by Ляпин Михаил on 22.07.2023.
//

import UIKit
import CoreLocation.CLLocation

protocol WWNewLocationDelegate: AnyObject {
    func newLocation(didAdd location: CLLocation)
}

final class WWAddNewLocationController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var giantPlus: UIImageView!
    @IBOutlet var tapOnPlus: UITapGestureRecognizer!
    
    weak var delegate: WWNewLocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        tapOnPlus.addTarget(self, action: #selector(addNewLocation))
        
    }
    
    private func setupSubview() {
        backgroundView.layer.cornerRadius = 20
        
    }
    
    @objc private func addNewLocation() {
        self.presentTextPicker(title: "Введите название новой локации", completion: { text in
            WWLocationService.shared.geocode(from: text) {[weak self] location in
                self?.delegate?.newLocation(didAdd: location) }
        })
    }
}
