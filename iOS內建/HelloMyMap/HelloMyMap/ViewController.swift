//
//  ViewController.swift
//  HelloMyMap
//
//  Created by user37 on 2018/1/30.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mainMapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization() //位置授權：於背景執行也可以取用位置
        
        //prepare locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位精確度
        locationManager.activityType = .automotiveNavigation //位置種類：automotive 自動車
        locationManager.startUpdatingLocation()
        
        mainMapView.delegate = self
        
        //背景更新位置
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let currentCoordinate=locationManager.location?.coordinate else {
            return
        }
        
        //縮放至目前位置
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: currentCoordinate, span: span)
        mainMapView.setRegion(region, animated: true)
        
        var storeCoordinate = currentCoordinate
        storeCoordinate.latitude += 0.001
        storeCoordinate.longitude += 0.001
        
        //加入圖釘
        let annotation = MKPointAnnotation()
        annotation.coordinate = storeCoordinate
        annotation.title = "金拱門"
        annotation.subtitle = "哈哈哈"
        mainMapView.addAnnotation(annotation)
    }
    
    //MARK:MKMapViewDelegate
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "store"
        
        //官方內建圖示
//        var result = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
//        if result == nil {
//            result = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
//        } else {
//            result?.annotation = annotation
//        }
//        result?.canShowCallout = true
//        result?.animatesDrop = true
//        result?.pinTintColor = UIColor.red

        var result = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        //如果已經有id就用，沒有就初始化一個
        if result == nil {
            result = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
        } else {
            result?.annotation = annotation
        }
        let image = UIImage.init(named: "pointRed.png")
        result?.image = image
        result?.canShowCallout = true //跳出提示
        
        
        result?.leftCalloutAccessoryView = UIImageView.init(image: UIImage.init(named: "pointRed.png"))
        
        let button = UIButton.init(type: .detailDisclosure)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        result?.rightCalloutAccessoryView = button
        
        return result
    }
    
    @objc func buttonTapped(sender:Any) {
        let alert = UIAlertController.init(title: nil, message: "Button tapped", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainMapView.mapType = .standard
        case 1:
            mainMapView.mapType = .satellite
        case 2:
            mainMapView.mapType = .hybrid
        case 3:
            mainMapView.mapType = .satelliteFlyover
            let coordinate = CLLocationCoordinate2D.init(latitude: 25.0392, longitude: 121.525)
            let camera = MKMapCamera.init(lookingAtCenter: coordinate, fromDistance: 700, pitch: 65, heading: 0)
            mainMapView.camera = camera
        default:
            mainMapView.mapType = .standard
        }
    }
    
    
    
    @IBAction func userTrackingModeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mainMapView.userTrackingMode = .none
        case 1:
            mainMapView.userTrackingMode = .follow
        case 2:
            mainMapView.userTrackingMode = .followWithHeading
        default:
            mainMapView.userTrackingMode = .none

        }
    }
    
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else {
            print("No coordinate")
            return
        }
        print("Current Location:\(coordinate.latitude),\(coordinate.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

