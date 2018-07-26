//
//  MapViewController.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 26/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    class CityAnnotation: NSObject, MKAnnotation {
        let coordinate: CLLocationCoordinate2D
        let name: String
        
        init(name: String, coordinate: CLLocationCoordinate2D) {
            self.name = name
            self.coordinate = coordinate
        }
        
        var subtitle: String? {
            return name
        }
    }
    var cities = [City]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var annotations = [CityAnnotation]()
        
        for city in cities {
            // With this check we avoid adding cities with null lat or long.
            if city.longitude != 0 && city.latitude != 0 {
                let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
                annotations.append(CityAnnotation(name: city.name!, coordinate: coordinate))
            }
        }
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
