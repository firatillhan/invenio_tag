//
//  CihazEkleViewModel.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import Foundation
import CoreBluetooth

protocol CihazBulViewModelDelegate: AnyObject {
    func cihazlarGuncellendi()
}

class CihazBulViewModel: NSObject, CBCentralManagerDelegate {
   
    weak var delegate: CihazBulViewModelDelegate?

    private var centralManager: CBCentralManager!
    
    private(set) var bulunanCihazlar: [DeviceFoundModel] = [] //set demek dışarıdan okuyabiliriz, ama değişteremeyiz
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func taramayiBaslat() {
        guard centralManager.state == .poweredOn else { return }
        bulunanCihazlar.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
    }
    
    func taramayiDurdur() {
        centralManager.stopScan()
    }
    
    //Bluetooth durumu her değiştiğinde otomatik çağrılan bir fonksiyon
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            taramayiBaslat()
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let isim = peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? ""
        
        guard !isim.isEmpty else { return }
        
        
        // Zaten kayıtlıysa gösterme
        let kayitliCihazlar = DeviceStorage.shared.allDevices()
        let kayitliMi = kayitliCihazlar.contains(where: { kayitliCihaz in
            kayitliCihaz.id == peripheral.identifier
        })
        guard !kayitliMi else { return }
        
        
        
        guard !bulunanCihazlar.contains(where: { bulunanCihaz in
            bulunanCihaz.peripheral?.identifier == peripheral.identifier
        }) else { return }
        
        let mac = String(peripheral.identifier.uuidString.prefix(17))     // MAC yerine peripheral identifier kullan (iOS gerçek MAC vermez)

        let cihaz = DeviceFoundModel(peripheral: peripheral, isim: isim, mac: mac, rssi: RSSI.intValue)
        bulunanCihazlar.append(cihaz)
        delegate?.cihazlarGuncellendi()

    }
}
