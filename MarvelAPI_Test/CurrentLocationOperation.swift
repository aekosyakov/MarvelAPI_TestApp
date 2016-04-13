//
//  CurrentLocationOperation.swift
//  TravelruSDK
//
//  Created by Alexander Kosyakov on 14.12.15.
//  Copyright © 2015 Andrey Kladov. All rights reserved.
//

import Foundation
import CoreLocation

public class CurrentLocationOperation: LocationOperation {
    private let failedHandler: NSError -> Void
    
    // MARK: Initialization
    public init(accuracy: CLLocationAccuracy, locationHandler: CLLocation -> Void, failedHandler: NSError -> Void) {
        self.failedHandler = failedHandler
        super.init(accuracy: accuracy, locationHandler: locationHandler)
    }
    
    // MARK: CLLocationManagerDelegate
    public override func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        super.locationManager(manager, didFailWithError: error)
        failedHandler(error)
    }
    
}