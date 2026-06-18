# invenio_tag


An AirTag alternative iOS app built with CoreBluetooth and MVVM architecture.

## Features
- Scan and pair nearby BLE devices (ESP32)
- Real-time RSSI and connection status monitoring
- Signal strength graph and distance estimation
- Last known location tracking with MapKit
- Device management (add, delete)

## Architecture
- MVVM pattern with delegate-based communication
- CoreBluetooth for BLE scanning and connection
- CoreLocation for location tracking
- UserDefaults for local storage (temporary, backend planned)

## Requirements
- iOS 16.0+
- Xcode 15+
- Bluetooth and Location permissions required

## Roadmap
- Backend integration
- Apple ID authentication
- Multi-device location sharing (Find My Network style)
- Device rename and icon editing


# invenio_tag

CoreBluetooth ve MVVM mimarisi ile geliştirilmiş AirTag alternatifi bir iOS uygulaması.

## Özellikler
- Yakındaki BLE cihazlarını (ESP32) tarama ve eşleştirme
- Gerçek zamanlı RSSI ve bağlantı durumu izleme
- Sinyal gücü grafiği ve mesafe tahmini
- MapKit ile son bilinen konum takibi
- Cihaz yönetimi (ekleme, silme)

## Mimari
- Delegate tabanlı iletişimle MVVM deseni
- BLE tarama ve bağlantı için CoreBluetooth
- Konum takibi için CoreLocation
- Geçici yerel depolama için UserDefaults (backend planlanıyor)

## Gereksinimler
- iOS 16.0+
- Xcode 15+
- Bluetooth ve Konum izinleri gerekli

## Yol Haritası
- Backend entegrasyonu
- Apple ID kimlik doğrulaması
- Çok cihazlı konum paylaşımı (Find My Network tarzı)
- Cihaz yeniden adlandırma ve ikon düzenleme