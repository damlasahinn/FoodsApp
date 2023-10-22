//
//  SiparisNerede.swift
//  FoodsApp
//
//  Created by Damla Sahin on 22.10.2023.
//

import UIKit
import MapKit
import CoreLocation

class SiparisNerede: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // ne kadar hassassa bataryayı o kadar tuketir
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        let apperance = UITabBarAppearance()
        apperance.backgroundColor = UIColor.black
        
        renkDegistir(itemAppearance: apperance.stackedLayoutAppearance)
        renkDegistir(itemAppearance: apperance.inlineLayoutAppearance)
        renkDegistir(itemAppearance: apperance.compactInlineLayoutAppearance)
        
        tabBarController?.tabBar.standardAppearance = apperance
        tabBarController?.tabBar.scrollEdgeAppearance = apperance
    }
    
    func renkDegistir(itemAppearance:UITabBarItemAppearance){
        itemAppearance.selected.iconColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        ]
        
        itemAppearance.normal.iconColor = UIColor.white
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white
        ]
        itemAppearance.normal.badgeBackgroundColor = UIColor.lightGray
        
    }

}
extension SiparisNerede : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sonKonum = locations[locations.count - 1]
        
        let enlem = sonKonum.coordinate.latitude
        let boylam = sonKonum.coordinate.longitude
        
        //41.0370013,28.974792
        let konum = CLLocationCoordinate2D(latitude: enlem, longitude: boylam)
        let zoom = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let bolge = MKCoordinateRegion(center: konum, span: zoom)
        mapView.setRegion(bolge, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = konum
        pin.title = "Konum"
        pin.subtitle = "\(enlem) - \(boylam)"
        mapView.addAnnotation(pin)
        
        mapView.showsUserLocation = true
        
    }
}
