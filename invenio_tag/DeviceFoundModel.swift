//
//  BulunanCihazlar.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import Foundation
import CoreBluetooth

struct DeviceFoundModel {
    let peripheral: CBPeripheral?
    let isim: String
    let mac: String         // Aslında peripheral.identifier (UUID), gerçek MAC değil
    var rssi: Int
}
