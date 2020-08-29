//
//  WeatherInfo.swift
//  HW9
//
//  Created by ARPIT on 4/14/20.
//  Copyright © 2020 ARPIT. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherInfo: UIViewController,CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestWhenInUseAuthorization()
//        locationManager?.requestLocation()
        debugPrint("aaaa")

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        getCurrentLocation(locations: locations)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//         print("error:: \(error.localizedDescription)")
//    }
//
//    func getCurrentLocation(locations: [CLLocation]) {
//            print("Getting location")
//            let lastCoord = locations.last
//            if (lastCoord != nil) {
//                let geocoder = CLGeocoder()
//                debugPrint("goel")
//                // Look up the location and pass it to the completion handler
//                geocoder.reverseGeocodeLocation(lastCoord!,
//                            completionHandler: { (placemarks, error) in
//                    if error == nil {
//                        debugPrint("arpit")
//                    }
//                    else {
//                        print("error:: get location failed, the return value of geocoding is nil")
//                    }
//                })
//            }
//            else {
//                print("error:: get location failed, the return value of lManager is nil")
//            }
//        }
//
//
    }
    
    
    
    
        
    

}
