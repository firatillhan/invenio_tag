//
//  CihazKaydetViewModel.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 17.06.2026.
//

import Foundation

class CihazKaydetViewModel {
    
    func cihaziKaydet(id:UUID,isim:String,ikon:String) {
        
        let yeniCihaz = DeviceModel(id: id, name: isim, icon: ikon, addedDate: Date(), lastSeen: Date(),lastRSSI: nil)
        
        DeviceStorage.shared.addDevice(yeniCihaz)

    }
}
