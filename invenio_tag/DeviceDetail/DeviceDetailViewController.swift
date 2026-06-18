//
//  DeviceDetailViewController.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 18.06.2026.
//

import UIKit

class DeviceDetailViewController: UIViewController {

    
    @IBOutlet weak var cihazNameLabel: UILabel!
    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusBadgeLabel: UILabel!
    @IBOutlet weak var rssiBadgeView: UIView!
    @IBOutlet weak var rssiBadgeLabel: UILabel!
    
    @IBOutlet weak var signalCardView: UIView!
    @IBOutlet weak var ringButton: UIButton!
    @IBOutlet weak var lastLocationButton: UIButton!
    
    
    // Signal Card içindeki bar'lar (kodla oluşacak)
    private var signalBars: [UIView] = []
    private var distanceValueLabel: UILabel!
    private var batteryValueLabel: UILabel!
    
    var cihaz: DeviceModel?
    private var sonGuncelleme: Date = .distantPast
    private let guncellemeAraligi: TimeInterval = 1  // saniyede 2 kez
    private var baglantiTimer: Timer?
    private var signalValueLabel: UILabel!
    
    
    private let viewModel = CihazTakipViewModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Tema.Renk.arkaPlan
        gorunumuKur()
        signalCardiKur()
        cihazVerisiniYukle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        viewModel.taramayiBaslat()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.taramayiDurdur()
    }
    
    // Cihaz verisi geldiğinde UI'ı doldur
    private func cihazVerisiniYukle() {
        guard let cihaz = cihaz else { return }
        cihazNameLabel.text = cihaz.name
        rssiBadgeLabel.text = "RSSI \(cihaz.lastRSSI ?? -100) dBm"
    }
    
    private func gorunumuKur() {
        //Cihaz İsmi
        cihazNameLabel.font = .systemFont(ofSize: 34, weight: .bold)
        cihazNameLabel.textColor = Tema.Renk.anaMetin
        
        //Status badge (yeşil pil)
        statusBadgeView.backgroundColor = Tema.Renk.ana
        statusBadgeView.layer.cornerRadius = 12
        statusBadgeLabel.text = "● Bağlı"
        statusBadgeLabel.font = .systemFont(ofSize: 11, weight: .medium)
        statusBadgeLabel.textColor = .white
        durumGuncelle(bagli: false)

        //RSSI badge (outline pill)
        rssiBadgeView.backgroundColor = .clear
        rssiBadgeView.layer.borderWidth = 1
        rssiBadgeView.layer.borderColor = Tema.Renk.kenarlik.cgColor
        rssiBadgeView.layer.cornerRadius = 12
        rssiBadgeLabel.text = "RSSI -58 dBm"
        rssiBadgeLabel.font = Tema.Font.etiket(11)
        rssiBadgeLabel.textColor = Tema.Renk.ikinciMetin
        
        // Signal Card
        signalCardView.backgroundColor = Tema.Renk.kartArkaPlan
        signalCardView.layer.cornerRadius = Tema.Olcu.kartKoseYumusakligi
        signalCardView.layer.borderWidth = 1
        signalCardView.layer.borderColor = Tema.Renk.kenarlik.cgColor
        
        // Çaldır butonu (siyah, primary)
//        ringButton.backgroundColor = Tema.Renk.anaMetin
//        ringButton.layer.cornerRadius = 16
//        ringButton.tintColor = .white
//        ringButton.setTitleColor(.black, for: .normal)
//        ringButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        // Son Konum (outline, secondary)
        lastLocationButton.backgroundColor = .white
        lastLocationButton.layer.cornerRadius = 14
        lastLocationButton.layer.borderWidth = 1
        lastLocationButton.layer.borderColor = Tema.Renk.kenarlik.cgColor
        lastLocationButton.setTitleColor(Tema.Renk.anaMetin, for: .normal)
        lastLocationButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

    }
    
    private func durumGuncelle(bagli: Bool) {
        print("durumGuncelle çağrıldı, bagli: \(bagli)")

        if bagli {
            statusBadgeView.backgroundColor = Tema.Renk.ana
            statusBadgeLabel.text = "● Bağlı"
            statusBadgeLabel.textColor = .white
        } else {
            statusBadgeView.backgroundColor = .clear
            statusBadgeView.layer.borderWidth = 1
            statusBadgeView.layer.borderColor = Tema.Renk.kenarlik.cgColor
            statusBadgeLabel.text = "○ Bağlı Değil"
            statusBadgeLabel.textColor = Tema.Renk.ucuncuMetin
        }
    }
    
    private func signalCardiKur() {
        // Ana vertical stack
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        signalCardView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: signalCardView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: signalCardView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: signalCardView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: signalCardView.bottomAnchor, constant: -20)
        ])
        
        // 1) Üst satır: SİNYAL + GÜÇLÜ
        let signalTitle = UILabel()
        signalTitle.text = "SİNYAL"
        signalTitle.font = Tema.Font.etiket(10)
        signalTitle.textColor = Tema.Renk.ucuncuMetin
        
        signalValueLabel = UILabel()
        signalValueLabel.text = "GÜÇLÜ"
        signalValueLabel.font = Tema.Font.etiketOrta(12)
        signalValueLabel.textColor = Tema.Renk.ana
        signalValueLabel.textAlignment = .right
        
        let headerStack = UIStackView(arrangedSubviews: [signalTitle, signalValueLabel])
        headerStack.axis = .horizontal
        headerStack.distribution = .fill
        mainStack.addArrangedSubview(headerStack)
        
        // 2) Bar grafiği — UIStackView ile
        let barsStack = UIStackView()
        barsStack.axis = .horizontal
        barsStack.distribution = .fillEqually
        barsStack.alignment = .bottom
        barsStack.spacing = 4
        barsStack.translatesAutoresizingMaskIntoConstraints = false
        barsStack.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let barYukseklikleri: [CGFloat] = [0.15, 0.25, 0.40, 0.55, 0.70, 0.82, 0.90, 0.95, 1.0, 0.92, 0.78, 0.60, 0.45, 0.32]
        let aktifBarSayisi = 11
        
        for (index, oran) in barYukseklikleri.enumerated() {
            let bar = UIView()
            bar.backgroundColor = Tema.Renk.ana
            bar.alpha = (index < aktifBarSayisi) ? 1.0 : 0.15
            bar.layer.cornerRadius = 2
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.heightAnchor.constraint(equalToConstant: 56 * oran).isActive = true
            
            barsStack.addArrangedSubview(bar)
            signalBars.append(bar)
        }
        
        mainStack.addArrangedSubview(barsStack)
        
        // 3) Alt grid: MESAFE | ayraç | PİL
        // Sol bölüm
        let distanceTitle = UILabel()
        distanceTitle.text = "MESAFE"
        distanceTitle.font = Tema.Font.etiket(10)
        distanceTitle.textColor = Tema.Renk.ucuncuMetin
        
        distanceValueLabel = UILabel()
        distanceValueLabel.text = "2.4 m"
        distanceValueLabel.font = .systemFont(ofSize: 28, weight: .regular)
        distanceValueLabel.textColor = Tema.Renk.anaMetin
        
        let leftStack = UIStackView(arrangedSubviews: [distanceTitle, distanceValueLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 4
        leftStack.alignment = .leading
        
        // Ayraç
        let divider = UIView()
        divider.backgroundColor = Tema.Renk.kenarlik
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Sağ bölüm
        let batteryTitle = UILabel()
        batteryTitle.text = "PİL"
        batteryTitle.font = Tema.Font.etiket(10)
        batteryTitle.textColor = Tema.Renk.ucuncuMetin
        
        batteryValueLabel = UILabel()
        batteryValueLabel.text = "---"
        batteryValueLabel.font = .systemFont(ofSize: 28, weight: .regular)
        batteryValueLabel.textColor = Tema.Renk.anaMetin
        
        let rightStack = UIStackView(arrangedSubviews: [batteryTitle, batteryValueLabel])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .leading
        
        let bottomStack = UIStackView(arrangedSubviews: [leftStack, divider, rightStack])
        bottomStack.axis = .horizontal
        bottomStack.spacing = 16
        bottomStack.alignment = .fill
        bottomStack.distribution = .fill
        
        // Sol ve sağ eşit genişlik
        leftStack.widthAnchor.constraint(equalTo: rightStack.widthAnchor).isActive = true
        
        mainStack.addArrangedSubview(bottomStack)
    }
    
    private func rssiUiGuncelle(rssi: Int) {
        durumGuncelle(bagli: true)
        // Timer'ı sıfırla — 3 saniye sonra bağlantı kopmuş say
        baglantiTimer?.invalidate()
        print("Timer kuruldu, 3 saniye bekliyor...")
        baglantiTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            print("Timer ateşlendi! Bağlı değil yapılıyor")
            self?.durumGuncelle(bagli: false)
        }
        // RSSI etiketi
        rssiBadgeLabel.text = "RSSI \(rssi) dBm"
        
        // Mesafe hesapla (yaklaşık)
        let mesafe = rssidenMesafe(rssi: rssi)
        distanceValueLabel.text = String(format: "%.1f m", mesafe)
        
        // Sinyal seviyesi (GÜÇLÜ/ORTA/ZAYIF)
        let durum: String
        let durumRengi: UIColor
        if rssi > -55 {
            durum = "ÇOK GÜÇLÜ"
            durumRengi = Tema.Renk.ana
        } else if rssi > -70 {
            durum = "GÜÇLÜ"
            durumRengi = Tema.Renk.ana
        } else if rssi > -85 {
            durum = "ORTA"
            durumRengi = .systemOrange
        } else {
            durum = "ZAYIF"
            durumRengi = Tema.Renk.tehlike
        }
        signalValueLabel.text = durum
        signalValueLabel.textColor = durumRengi
        // signalValueLabel global değil — kodda local olarak oluşturduğumuz label
        // Şu an dokunamıyoruz, ama mesafe ve RSSI etiketleri yeterli
        
        // Bar grafiğini güncelle
        barGrafigiGuncelle(rssi: rssi)
        
        // Son görülen olarak kaydet
        if var cihaz = cihaz {
            cihaz.lastRSSI = rssi
            cihaz.lastSeen = Date()
           // DeviceStorage.shared
            self.cihaz = cihaz
        }
        
    }
    
    // RSSI'dan mesafe tahmini
    // RSSI = -10 * n * log10(d) + A formülü
    // A = 1m mesafedeki RSSI (kalibrasyon), n = path loss exponent (~2)
    private func rssidenMesafe(rssi: Int) -> Double {
        let A = -55.0  // 1m mesafedeki referans RSSI (kalibrasyon)
        let n = 2.0    // ortam faktörü
        
        let mesafe = pow(10.0, (A - Double(rssi)) / (10 * n))
        return min(max(mesafe, 0.1), 100.0)  // 0.1m ile 100m arası kıs
    }
    
    // Bar grafiğini RSSI'ya göre güncelle
    private func barGrafigiGuncelle(rssi: Int) {
        let toplamBar = signalBars.count  // 14
        
        // RSSI -100 (en kötü) ile -30 (en iyi) arası
        // -30 = 14 bar, -100 = 0 bar
        let normalize = max(0.0, min(1.0, Double(rssi + 100) / 70.0))
        let aktifBar = Int(Double(toplamBar) * normalize)
        
        for (index, bar) in signalBars.enumerated() {
            UIView.animate(withDuration: 0.3) {
                bar.alpha = (index < aktifBar) ? 1.0 : 0.15
            }
        }
    }
    
    @IBAction func lastLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "sonKonumSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sonKonumSegue",
           let hedefVC = segue.destination as? DeviceLocationViewController {
            hedefVC.cihaz = cihaz
        }
    }
    @IBAction func deviceDeleteButton(_ sender: Any) {
        guard let cihaz = cihaz else { return }
        
        let alert = UIAlertController(
            title: "Cihazı Sil",
            message: "\(cihaz.name) silinecek. Emin misin?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive) { _ in
            DeviceStorage.shared.deleteDevice(id: cihaz.id)
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
        
    }
    
    
    
}


extension DeviceDetailViewController: CihazTakipViewModelDelegate {
    func cihazlarGuncellendi() {
        guard let cihaz = cihaz else { return }
        
        let bagli = viewModel.bagliMi(id: cihaz.id)
        
        if bagli, let rssi = viewModel.canliRSSI[cihaz.id] {
            rssiUiGuncelle(rssi: rssi)
        } else {
            durumGuncelle(bagli: false)
        }
    }
}
