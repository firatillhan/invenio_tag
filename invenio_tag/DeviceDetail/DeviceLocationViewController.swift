//
//  DeviceLocationViewController.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 18.06.2026.
//

import UIKit
import MapKit

class DeviceLocationViewController: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    var cihaz:DeviceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        konumuGoster()
    }
    

    private func konumuGoster() {
        guard let cihaz = cihaz,
              let lat = cihaz.lastLatitude,
              let lon = cihaz.lastLongitude else {
            print("Konum bilgisi yok")
            return
        }
        
        let koordinat = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // Pin ekle
        let annotation = MKPointAnnotation()
        annotation.coordinate = koordinat
        annotation.title = cihaz.name
        mapKit.addAnnotation(annotation)
        
        // Haritayı o konuma odakla
        let region = MKCoordinateRegion(
            center: koordinat,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        mapKit.setRegion(region, animated: true)
    }
  
    

}
