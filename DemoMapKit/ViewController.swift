//
//  ViewController.swift
//  DemoMapKit
//
//  Created by Le Kim Tuan on 9/26/15.
//  Copyright © 2015 Le Kim Tuan. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    let locationManager = CLLocationManager()
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=16.066667,108.23333&radius=5000&types=atm&name=vietcombank&key=AIzaSyADSGUtQ4ssp4Z6pszLMcpL24W3eobN8jo", parameters: nil)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    func createViewWithAnnotation(annotation: MKAnnotation, identifier: String) -> MKPinAnnotationView {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.enabled = true
        annotationView.canShowCallout = true
        annotationView.animatesDrop = false
        annotationView.pinTintColor = UIColor.blueColor()
        
        let rightButton = UIButton(type: .DetailDisclosure)
        rightButton.addTarget(self, action: Selector("showLocationDetails:"), forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.rightCalloutAccessoryView = rightButton
        
        let leftButton = UIButton(type: .ContactAdd)
        leftButton.addTarget(self, action: Selector("testLeftButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        annotationView.leftCalloutAccessoryView = leftButton
        
        return annotationView
    }
    
    func testLeftButton(sender: UIButton) {
        print("left button")
    }
    
    func showLocationDetails(sender: UIButton) {
        print("show location details")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MyAnnotation {
            var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("MyAnnotationId") as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = createViewWithAnnotation(annotation, identifier: "MyAnnotationId")
            }else{
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        centerMapOnLocation(mapView.userLocation.location!)
        let location = mapView.userLocation.location
        let annotation = MyAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        annotation.title = "I'm here"
        annotation.subtitle = "An Don, Da Nang"
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

