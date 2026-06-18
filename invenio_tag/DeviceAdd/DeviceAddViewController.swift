//
//  DeviceAddViewController.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import UIKit
import CoreBluetooth

class DeviceAddViewController: UIViewController {
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var scanIndicatorView: UIView!
    @IBOutlet weak var foundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pairButton: UIBarButtonItem!
    
    private var bulunanCihazlar: [DeviceFoundModel] = []

    private var bulViewModel = CihazBulViewModel()
    private let kaydetViewModel = CihazKaydetViewModel()

    private var seciliIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = Tema.Renk.arkaPlan
        gorunumuKur()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
        bulViewModel.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bulViewModel.taramayiBaslat()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bulViewModel.taramayiDurdur()
    }
    
    private func gorunumuKur() {

        subtitleLabel.font = Tema.Font.govde(13)
        subtitleLabel.textColor = Tema.Renk.ucuncuMetin
        
        scanIndicatorView.backgroundColor = .clear
        taramaIndicatorEkle()
        
        // Found label
        foundLabel.font = Tema.Font.etiket(11)
        foundLabel.textColor = Tema.Renk.ucuncuMetin
        foundLabel.text = "BULUNAN CİHAZLAR · \(bulunanCihazlar.count)"
        
    }
    private func taramaIndicatorEkle() {
        // Yeşil daire (merkez)
        let yesilDaire = UIView()
        yesilDaire.backgroundColor = Tema.Renk.ana
        yesilDaire.layer.cornerRadius = 32
        yesilDaire.translatesAutoresizingMaskIntoConstraints = false
        
        // Pulse halkaları için container (dairenin arkasında)
        let pulseContainer = UIView()
        pulseContainer.translatesAutoresizingMaskIntoConstraints = false
        scanIndicatorView.addSubview(pulseContainer)
        scanIndicatorView.addSubview(yesilDaire)  // daire pulse'ın üstünde
        
        // İçeride beyaz nokta (radar antenni)
        let beyazNokta = UIView()
        beyazNokta.backgroundColor = .white
        beyazNokta.layer.cornerRadius = 4
        beyazNokta.translatesAutoresizingMaskIntoConstraints = false
        yesilDaire.addSubview(beyazNokta)
        
        // "ARANIYOR" yazısı
        let scanLabel = UILabel()
        scanLabel.text = "ARANIYOR · SCANNING"
        scanLabel.font = Tema.Font.etiketOrta(11)
        scanLabel.textColor = Tema.Renk.ana
        scanLabel.textAlignment = .center
        scanLabel.translatesAutoresizingMaskIntoConstraints = false
        scanIndicatorView.addSubview(scanLabel)
        
        NSLayoutConstraint.activate([
            // Yeşil daire (merkez)
            yesilDaire.centerXAnchor.constraint(equalTo: scanIndicatorView.centerXAnchor),
            yesilDaire.centerYAnchor.constraint(equalTo: scanIndicatorView.centerYAnchor, constant: -12),
            yesilDaire.widthAnchor.constraint(equalToConstant: 64),
            yesilDaire.heightAnchor.constraint(equalToConstant: 64),
            
            // Pulse container (dairenin etrafına)
            pulseContainer.centerXAnchor.constraint(equalTo: yesilDaire.centerXAnchor),
            pulseContainer.centerYAnchor.constraint(equalTo: yesilDaire.centerYAnchor),
            pulseContainer.widthAnchor.constraint(equalToConstant: 64),
            pulseContainer.heightAnchor.constraint(equalToConstant: 64),
            
            // Beyaz nokta (dairenin ortasında)
            beyazNokta.centerXAnchor.constraint(equalTo: yesilDaire.centerXAnchor),
            beyazNokta.centerYAnchor.constraint(equalTo: yesilDaire.centerYAnchor),
            beyazNokta.widthAnchor.constraint(equalToConstant: 8),
            beyazNokta.heightAnchor.constraint(equalToConstant: 8),
            
            // Label
            // Label - view'ın alt kenarına sabitlendi
            scanLabel.bottomAnchor.constraint(equalTo: scanIndicatorView.bottomAnchor),
            scanLabel.centerXAnchor.constraint(equalTo: scanIndicatorView.centerXAnchor)
        ])
        
        // Layout uygulansın diye bir frame'lik bekle
        DispatchQueue.main.async {
            self.pulseAnimasyonuBaslat(in: pulseContainer)
        }
    }
    private func pulseAnimasyonuBaslat(in container: UIView) {
        // 2 adet pulse halkası — üst üste, gecikmeli
        for i in 0..<2 {
            let pulse = CALayer()
            pulse.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
            pulse.cornerRadius = 32
            pulse.borderWidth = 2
            pulse.borderColor = Tema.Renk.ana.cgColor
            pulse.opacity = 0
            container.layer.addSublayer(pulse)
            
            // Animasyon
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 0.5
            scaleAnim.toValue = 2.2
            
            let opacityAnim = CABasicAnimation(keyPath: "opacity")
            opacityAnim.fromValue = 0.8
            opacityAnim.toValue = 0
            
            let group = CAAnimationGroup()
            group.animations = [scaleAnim, opacityAnim]
            group.duration = 2.0
            group.repeatCount = .infinity
            group.beginTime = CACurrentMediaTime() + Double(i) * 1.0  // ikincisi 1sn gecikmeli
            
            pulse.add(group, forKey: "pulse")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ikonSecimiSegue",
           let hedefVC = segue.destination as? DeviceNameIconViewController,
           let cihaz = sender as? DeviceFoundModel {
            hedefVC.bulunanCihaz = cihaz
            hedefVC.tamamlandi = { [weak self] isim, ikon in
                guard let self = self else { return }
                guard let peripheral = cihaz.peripheral else { return }
                
                self.kaydetViewModel.cihaziKaydet(id: peripheral.identifier, isim: isim, ikon: ikon)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}


extension DeviceAddViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bulunanCihazlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceAddTableViewCell
        
        let cihaz = bulunanCihazlar[indexPath.row]
        let secili = seciliIndex == indexPath.row
        cell.yapilandir(isim: cihaz.isim, mac: cihaz.mac, rssi: cihaz.rssi, secili: secili)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        seciliIndex = indexPath.row
        tableView.reloadData()
        performSegue(withIdentifier: "ikonSecimiSegue", sender: bulunanCihazlar[indexPath.row])

    }
    

    
}
extension DeviceAddViewController: CihazBulViewModelDelegate {
    func cihazlarGuncellendi() {
        bulunanCihazlar = bulViewModel.bulunanCihazlar
        foundLabel.text = "BULUNAN CİHAZLAR · \(bulunanCihazlar.count)"
        tableView.reloadData()
    }
}

