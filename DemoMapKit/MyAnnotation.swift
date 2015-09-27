//
//  MyAnnotation.swift
//  DemoMapKit
//
//  Created by Le Kim Tuan on 9/26/15.
//  Copyright © 2015 Le Kim Tuan. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
}
