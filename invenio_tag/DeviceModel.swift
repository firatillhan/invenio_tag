//
//  Device.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import Foundation

struct DeviceModel: Codable {
    let id: UUID           // Cihazın benzersiz kimliği (peripheral.identifier)
    var name: String       // Kullanıcının verdiği isim
    var icon: String       // Seçilen emoji
    var addedDate: Date    // Eklenme tarihi
    var lastSeen: Date?    // Son görülme zamanı
    var lastRSSI: Int?     // Son sinyal gücü
    
    var lastLatitude: Double?
    var lastLongitude: Double?
}

