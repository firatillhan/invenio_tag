//
//  DeviceListTableViewCell.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import UIKit

class DeviceListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    
    private let ikonLabel = UILabel()
    private let isimLabel = UILabel()
    private let metaLabel = UILabel()
    private let sinyalView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        setupCardView()
        setupUI()
        setupConstraints()
    }
    
    private func setupCardView() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 234/255, alpha: 1.0).cgColor
    }
    
    private func setupUI() {
        // İkon
        ikonLabel.font = .systemFont(ofSize: 28)
        ikonLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(ikonLabel)
        
        // İsim
        isimLabel.font = Tema.Font.baslikKucuk(17)
        isimLabel.textColor = Tema.Renk.anaMetin
        isimLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(isimLabel)
        
        // Meta
        metaLabel.font = Tema.Font.etiket(10)
        metaLabel.textColor = Tema.Renk.ucuncuMetin
        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(metaLabel)
        
        // Sinyal
        sinyalView.contentMode = .scaleAspectFit
        sinyalView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(sinyalView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // İkon
            ikonLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            ikonLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            ikonLabel.widthAnchor.constraint(equalToConstant: 40),
            
            // İsim
            isimLabel.leadingAnchor.constraint(equalTo: ikonLabel.trailingAnchor, constant: 12),
            isimLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            isimLabel.trailingAnchor.constraint(equalTo: sinyalView.leadingAnchor, constant: -8),
            
            // Meta
            metaLabel.leadingAnchor.constraint(equalTo: isimLabel.leadingAnchor),
            metaLabel.topAnchor.constraint(equalTo: isimLabel.bottomAnchor, constant: 4),
            metaLabel.trailingAnchor.constraint(equalTo: isimLabel.trailingAnchor),
            
            // Sinyal
            sinyalView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            sinyalView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            sinyalView.widthAnchor.constraint(equalToConstant: 24),
            sinyalView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    func yapilandir(device: DeviceModel, rssi: Int?, bagli: Bool, canliSonGorulme: Date?) {
        ikonLabel.text = device.icon
        isimLabel.text = device.name
        
        // Meta
        if bagli, let rssi = rssi {
            metaLabel.text = "BAĞLI · \(rssi) dBm"
            metaLabel.textColor = Tema.Renk.ana
        } else if let sonGorulme = canliSonGorulme ?? device.lastSeen {
            let formatter = RelativeDateTimeFormatter()
            formatter.locale = Locale(identifier: "tr_TR")
            metaLabel.text = "SON: \(formatter.localizedString(for: sonGorulme, relativeTo: Date()).uppercased())"
            metaLabel.textColor = Tema.Renk.ucuncuMetin
        } else {
            metaLabel.text = "Henüz bağlanmadı"
            metaLabel.textColor = Tema.Renk.ucuncuMetin
        }
        
        // Sinyal
        let oran = bagli ? Double(max(0, min(4, (rssi ?? -100) + 100))) / 4.0 : 0.0
        if #available(iOS 16.0, *) {
            sinyalView.image = UIImage(systemName: "cellularbars", variableValue: oran)
        } else {
            sinyalView.image = UIImage(systemName: "cellularbars")
        }
        sinyalView.tintColor = bagli ? Tema.Renk.ana : Tema.Renk.ucuncuMetin
        
        // Offline görünüm
        cardView.backgroundColor = bagli ? .white : UIColor(red: 244/255, green: 244/255, blue: 240/255, alpha: 1.0)
        contentView.alpha = bagli ? 1.0 : 0.7
    }
}
