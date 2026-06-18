////
////  ViewController.swift
////  invenio_tag
////
////  Created by Fırat İlhan on 16.06.2026.
////
//
//import UIKit
//import CoreBluetooth
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    private var  centralManager: CBCentralManager!
//    private var bulunanCihazlar: [BulunanCihaz] = []
//    private var secilenPeripheral: CBPeripheral?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        tableView.dataSource = self
//        tableView.delegate = self
//        centralManager = CBCentralManager(delegate: self, queue: .main)
//    }
//
//
//}
//
//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bulunanCihazlar.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        let cihaz = bulunanCihazlar[indexPath.row]
//        cell.textLabel?.text = cihaz.peripheral.name ?? "İsimsiz"
//        cell.detailTextLabel?.text = "\(cihaz.rssi) dBm"
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cihaz = bulunanCihazlar[indexPath.row]
//        secilenPeripheral = cihaz.peripheral
//        secilenPeripheral?.delegate = self
//        centralManager.stopScan()
//        centralManager.connect(cihaz.peripheral, options: nil)
//        print("Bağlanmaya çalışılıyor: \(cihaz.peripheral.name ?? "?")")
//    }
//}
//
//                    
//extension ViewController: CBCentralManagerDelegate {
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state {
//        case .poweredOn:
//            print("Bluetooth is on")
//            central.scanForPeripherals(withServices: nil, options: nil)
//            print("Tarama başladı")
//        case .poweredOff:
//            print("Bluetooth is off")
//        case .unauthorized:
//            print("no permission")
//        default:
//            print("Other state: \(central.state.rawValue)")
//
//        }
//    }
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
//        
//        guard RSSI.intValue > -70 else { return }
//
//        
////        if !bulunanCihazlar.contains(where: { $0.peripheral == peripheral }) {
////            let cihaz = BulunanCihaz(peripheral: peripheral, rssi: RSSI.intValue)
////            bulunanCihazlar.append(cihaz)
////            tableView.reloadData()
////        }
//    }
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("Bağlandı: \(peripheral.name ?? "?")")
//        
//        peripheral.discoverServices(nil) // nil = tüm servisleri keşfet ----------- discoverServices bağlanan cihazın servislerini keşfeder.
//
//    }
//
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print("Bağlantı başarısız: \(error?.localizedDescription ?? "?")")
//    }
//}
//
//extension ViewController: CBPeripheralDelegate {
//    // didDiscoverServices keşif tamamlanınca çağrılır.
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        guard let services = peripheral.services else { return }
//        
//        for service in services {
//            print("Servis bulundu: \(service.uuid)")
//            peripheral.discoverCharacteristics(nil, for: service) // nil = tüm characteristic'leri keşfet
//
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        guard let characteristics = service.characteristics else { return }
//        
//        for char in characteristics {
//            print("Characteristic bulundu: \(char.uuid) | Özellikler: \(char.properties)")
//            
//            // Yazma özelliği varsa "1" gönder
//            if char.properties.contains(.write) {
//                let veri = "1".data(using: .utf8)!
//                peripheral.writeValue(veri, for: char, type: .withResponse)
//                print("Komut gönderildi")
//            }
//
//            
//            
//        }
//    }
//}
