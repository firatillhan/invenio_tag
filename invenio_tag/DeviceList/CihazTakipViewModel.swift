//
//  CihazTakipViewModel.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 17.06.2026.
//

import Foundation
import CoreBluetooth
import CoreLocation

protocol CihazTakipViewModelDelegate: AnyObject {
    func cihazlarGuncellendi()
}

class CihazTakipViewModel: NSObject {
    
    private var centralManager: CBCentralManager!
    
    private(set) var canliRSSI: [UUID: Int] = [:]
    private(set) var canliGorulme: [UUID: Date] = [:]

    weak var delegate: CihazTakipViewModelDelegate?
    
    private var kontrolTimer: Timer?
    private let konumViewModel = KonumViewModel.shared
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func taramayiBaslat() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        
        kontrolTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.delegate?.cihazlarGuncellendi()
        }
        
    }
    
    func taramayiDurdur() {
        centralManager.stopScan()
        kontrolTimer?.invalidate()
        kontrolTimer = nil
    }
    
    func bagliMi(id: UUID) -> Bool {
        guard let gorulme = canliGorulme[id] else { return false }
        return Date().timeIntervalSince(gorulme) < 10
    }
    
}

extension CihazTakipViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            taramayiBaslat()
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard RSSI.intValue < 0 else { return }

        let id = peripheral.identifier

        // Sadece kayıtlı cihazlardan biriyse ilgilen
        let kayitliCihazlar = DeviceStorage.shared.allDevices()
        
        guard kayitliCihazlar.contains(where: { kayitliCihaz in
            kayitliCihaz.id == id
        }) else { return }
        
        canliRSSI[id] = RSSI.intValue
        canliGorulme[id] = Date()
        
        
        
       if let konum = konumViewModel.sonKonum {
           print("Konum alındı: \(konum.coordinate.latitude), \(konum.coordinate.longitude)")

           if var cihaz = kayitliCihazlar.first(where: { kayitliCihaz in
               kayitliCihaz.id == id
           }) {
               cihaz.lastLatitude = konum.coordinate.latitude
               cihaz.lastLongitude = konum.coordinate.longitude
               cihaz.lastSeen = Date()
               DeviceStorage.shared.updateDevice(cihaz)

           }
       } else {
           print("Konum nil")
       }
        
        delegate?.cihazlarGuncellendi()
        
    }
    
    
}
