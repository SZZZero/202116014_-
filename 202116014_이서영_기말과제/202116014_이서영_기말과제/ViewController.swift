//
//  ViewController.swift
//  202116014_이서영_기말과제
//
//  Created by 203a05 on 2022/06/16.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var myMap: MKMapView!
    
    let locationmanager = CLLocationManager()
    var previousCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        myMap.showsUserLocation = true
    
        getLocationUsagePermission()
    }
    
    func getLocationUsagePermission(){
         locationmanager.requestWhenInUseAuthorization()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.locationmanager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
                
            case .restricted, .notDetermined:
                print("GPS 권한 설정되지 않음")
                DispatchQueue.main.async{
                    self.getLocationUsagePermission()
                }
                
            case .denied:
                print("GPS 권한 요청 거부됨")
                DispatchQueue.main.async {
                    self.getLocationUsagePermission()
                }
                
            default:
                print("GPS: Default")
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last
                
        else {return}
        
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        if let previousCoordinate = self.previousCoordinate {
            
        var points: [CLLocationCoordinate2D] = []
            
        let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
        let point2: CLLocationCoordinate2D
        = CLLocationCoordinate2DMake(latitude, longtitude)
            
        points.append(point1)
        points.append(point2)
            
        let lineDraw = MKPolyline(coordinates: points, count:points.count)
        self.myMap.addOverlay(lineDraw)
            
        }

        self.previousCoordinate = location.coordinate
    }
    
    
    func myMap (_ myMap: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           guard let polyLine = overlay as? MKPolyline
           else {
               print("선을 그릴 수 없습니다")
               return MKOverlayRenderer()
           }
           let renderer = MKPolylineRenderer(polyline: polyLine)
               renderer.strokeColor = .green
               renderer.lineWidth = 5.0

           return renderer
       }
}

