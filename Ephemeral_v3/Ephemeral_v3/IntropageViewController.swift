//
//  IntropageViewController.swift
//  Ephemeral_v3
//
//  Created by Chang Gao on 4/29/18.
//  Copyright © 2018 Ephemeral. All rights reserved.
//

import UIKit
import CoreLocation


class IntropageViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            print(location.coordinate)
            //            let location1 = CLLocation(latitude: 24.953232, longitude: 121.225353)
            let location2 = CLLocation(latitude: 40.7619, longitude: -74.0018)
            let distanceInMeters : CLLocationDistance = location.distance(from: location2)
            if(distanceInMeters <= 1609)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let ViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
                //ViewController
                self.present(ViewController, animated: true, completion: nil)
                print("under 1 mile")
                // under 1 mile
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let AnimationLoopViewController = storyboard.instantiateViewController(withIdentifier: "AnimationLoopViewController")
                
                self.present(AnimationLoopViewController, animated: true, completion: nil)
                print("out of 1 mile")
                // out of 1 mile
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
