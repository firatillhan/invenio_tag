//
//  DeviceAddTableViewCell.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import UIKit

class DeviceAddTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    
    private let ikonImageView = UIImageView()
    private let isimLabel = UILabel()
    private let macLabel = UILabel()
    private let rssiLabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
        setupCardView()
        setupUI()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        cardView.layer.borderColor = selected ? UIColor.systemGreen.cgColor : UIColor(red: 236/255, green: 236/255, blue: 234/255, alpha: 1.0).cgColor
//        cardView.layer.borderWidth = selected ? 2 : 1
    }
    
    private func setupCardView() {
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 234/255, alpha: 1.0).cgColor
    }
    private func setupUI() {
          // İkon
          ikonImageView.image = UIImage(systemName: "antenna.radiowaves.left.and.right")
          ikonImageView.tintColor = .systemGreen
          ikonImageView.contentMode = .scaleAspectFit
          ikonImageView.translatesAutoresizingMaskIntoConstraints = false
          cardView.addSubview(ikonImageView)
          
          // İsim
          isimLabel.font = .systemFont(ofSize: 17, weight: .semibold)
          isimLabel.textColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
          isimLabel.translatesAutoresizingMaskIntoConstraints = false
          cardView.addSubview(isimLabel)
          
          // MAC
          macLabel.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
          macLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
          macLabel.translatesAutoresizingMaskIntoConstraints = false
          cardView.addSubview(macLabel)
          
          // RSSI
          rssiLabel.font = .monospacedSystemFont(ofSize: 13, weight: .medium)
          rssiLabel.textColor = .systemGreen
          rssiLabel.textAlignment = .right
          rssiLabel.translatesAutoresizingMaskIntoConstraints = false
          cardView.addSubview(rssiLabel)
      }
      
      private func setupConstraints() {
          NSLayoutConstraint.activate([
              // İkon
              ikonImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
              ikonImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
              ikonImageView.widthAnchor.constraint(equalToConstant: 36),
              ikonImageView.heightAnchor.constraint(equalToConstant: 36),
              
              // İsim
              isimLabel.leadingAnchor.constraint(equalTo: ikonImageView.trailingAnchor, constant: 12),
              isimLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
              isimLabel.trailingAnchor.constraint(equalTo: rssiLabel.leadingAnchor, constant: -8),
              
              // MAC
              macLabel.leadingAnchor.constraint(equalTo: isimLabel.leadingAnchor),
              macLabel.topAnchor.constraint(equalTo: isimLabel.bottomAnchor, constant: 4),
              macLabel.trailingAnchor.constraint(equalTo: isimLabel.trailingAnchor),
              
              // RSSI
              rssiLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
              rssiLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
              rssiLabel.widthAnchor.constraint(equalToConstant: 70)
          ])
      }
      
    func yapilandir(isim: String, mac: String, rssi: Int, secili: Bool) {
        isimLabel.text = isim
        macLabel.text = mac
        rssiLabel.text = "\(rssi) dBm"
        
        cardView.layer.borderColor = secili ? UIColor.systemGreen.cgColor : UIColor(red: 236/255, green: 236/255, blue: 234/255, alpha: 1.0).cgColor
        cardView.layer.borderWidth = secili ? 2 : 1
    }
  }
