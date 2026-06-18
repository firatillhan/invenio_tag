//
//  DeviceStorage.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import Foundation

class DeviceStorage {
    
    static let shared = DeviceStorage()
    private let key = "kayitliCihazlar"
    
    private init() {}
       
    func allDevices() -> [DeviceModel] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let devices = try? JSONDecoder().decode([DeviceModel].self, from: data) else {
            return []
        }
        return devices
    }
    
    func addDevice(_ device: DeviceModel) {
        var devices = allDevices()
        let zatenVarMi = devices.contains(where: { mevcutCihaz in
              mevcutCihaz.id == device.id
          })
        guard !zatenVarMi else { return }
        devices.append(device)
        do {
            let data = try JSONEncoder().encode(devices)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Kaydetme hatası: \(error.localizedDescription)")
        }
    }
    
    func updateDevice(_ device: DeviceModel) {
        var devices = allDevices()
        
        guard let index = devices.firstIndex(where: { mevcutCihaz in
            mevcutCihaz.id == device.id
        }) else { return }
        
        devices[index] = device
        
        do {
            let data = try JSONEncoder().encode(devices)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Güncelleme hatası: \(error.localizedDescription)")
        }
    }
    
    
    func deleteDevice(id: UUID) {
        var devices = allDevices()
        devices.removeAll(where: { mevcutCihaz in
            mevcutCihaz.id == id
        })
        
        do {
            let data = try JSONEncoder().encode(devices)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Silme hatası: \(error.localizedDescription)")
        }
    }
    
    
}
    
 
    
  
  

