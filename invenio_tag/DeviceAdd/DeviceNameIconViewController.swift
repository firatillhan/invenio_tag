//
//  IsimVeIkonSecimiViewController.swift
//  Invera
//
//  Created by Fırat İlhan on 15.06.2026.
//

import UIKit

class DeviceNameIconViewController: UIViewController {
    
    var bulunanCihaz: DeviceFoundModel?
    var tamamlandi: ((String, String) -> Void)?  // isim, ikon
    
    private let ikonlar = ["🔑", "🎒", "👜", "🧳", "📱", "💻", "🎮", "🚗", "🐶", "✏️"]
    private var seciliIkon: String = "🔑"
    
    // MARK: - UI Elemanları
    private let containerView = UIView()
    private let tutamakView = UIView()
    private let baslikLabel = UILabel()
    private let isimLabel = UILabel()
    private let isimTextField = UITextField()
    private let ikonBaslikLabel = UILabel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let itemGenislik = (UIScreen.main.bounds.width - 48 - 40 - 10) / 5  // 5 sütun
        layout.itemSize = CGSize(width: itemGenislik, height: itemGenislik)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    private let kaydetButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupContainer()
        setupUI()
        setupConstraints()
        
        // Varsayılan isim
        isimTextField.text = bulunanCihaz?.isim ?? "Cihaz"
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeAcildi(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(klavyeKapandi(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animasyonluAc()
    }
    
    // MARK: - Kurulum
    private func setupContainer() {
        // Arka plan karartma
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(kapat))
        dimView.addGestureRecognizer(tap)
        
        // Container (bottom sheet)
        containerView.backgroundColor = Tema.Renk.arkaPlan
        containerView.layer.cornerRadius = 24
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    }
    
    private func setupUI() {
        // Tutamak
        tutamakView.backgroundColor = Tema.Renk.ayrac
        tutamakView.layer.cornerRadius = 2
        tutamakView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tutamakView)
        
        // Başlık
        baslikLabel.text = "Cihaz Ekle"
        baslikLabel.font = Tema.Font.baslikKucuk(17)
        baslikLabel.textColor = Tema.Renk.anaMetin
        baslikLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(baslikLabel)
        
        // İsim label
        isimLabel.text = "Cihaz İsmi"
        isimLabel.font = Tema.Font.govdeOrta(13)
        isimLabel.textColor = Tema.Renk.ikinciMetin
        isimLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(isimLabel)
        
        // TextField
        isimTextField.font = Tema.Font.govde(15)
        isimTextField.textColor = Tema.Renk.anaMetin
        isimTextField.backgroundColor = Tema.Renk.kartArkaPlan
        isimTextField.layer.cornerRadius = 12
        isimTextField.layer.borderWidth = 0.5
        isimTextField.layer.borderColor = Tema.Renk.kenarlik.cgColor
        isimTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        isimTextField.leftViewMode = .always
        isimTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(isimTextField)
        
        // İkon başlık
        ikonBaslikLabel.text = "İKON SEÇ"
        ikonBaslikLabel.font = Tema.Font.etiket(11)
        ikonBaslikLabel.textColor = Tema.Renk.ucuncuMetin
        ikonBaslikLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ikonBaslikLabel)
        
        // Collection View
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IkonHucresi.self, forCellWithReuseIdentifier: "IkonHucresi")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(collectionView)
        
        // Kaydet butonu
        kaydetButton.setTitle("Kaydet", for: .normal)
        kaydetButton.titleLabel?.font = Tema.Font.govdeOrta(15)
        kaydetButton.setTitleColor(.white, for: .normal)
        kaydetButton.backgroundColor = Tema.Renk.ana
        kaydetButton.layer.cornerRadius = 14
        kaydetButton.addTarget(self, action: #selector(kaydetTapped), for: .touchUpInside)
        kaydetButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(kaydetButton)
    }
    
    private func setupConstraints() {
        let itemGenislik = (UIScreen.main.bounds.width - 48 - 40) / 5
        let collectionYukseklik = itemGenislik * 2 + 10  // 2 satır
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tutamakView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            tutamakView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            tutamakView.widthAnchor.constraint(equalToConstant: 40),
            tutamakView.heightAnchor.constraint(equalToConstant: 4),
            
            baslikLabel.topAnchor.constraint(equalTo: tutamakView.bottomAnchor, constant: 16),
            baslikLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            isimLabel.topAnchor.constraint(equalTo: baslikLabel.bottomAnchor, constant: 20),
            isimLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            isimTextField.topAnchor.constraint(equalTo: isimLabel.bottomAnchor, constant: 8),
            isimTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            isimTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            isimTextField.heightAnchor.constraint(equalToConstant: 44),
            
            ikonBaslikLabel.topAnchor.constraint(equalTo: isimTextField.bottomAnchor, constant: 20),
            ikonBaslikLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            collectionView.topAnchor.constraint(equalTo: ikonBaslikLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            collectionView.heightAnchor.constraint(equalToConstant: collectionYukseklik),
            
            kaydetButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            kaydetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            kaydetButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            kaydetButton.heightAnchor.constraint(equalToConstant: 50),
            kaydetButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    @objc private func klavyeAcildi(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let klavyeYuksekligi = keyboardFrame.height
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -klavyeYuksekligi)
        }
    }

    @objc private func klavyeKapandi(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
        }
    }
    // MARK: - Animasyon
    private func animasyonluAc() {
        containerView.transform = CGAffineTransform(translationX: 0, y: containerView.bounds.height)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0) {
            self.containerView.transform = .identity
        }
    }
    
    @objc private func kapat() {
        UIView.animate(withDuration: 0.25) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.bounds.height)
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc private func kaydetTapped() {
        let isim = isimTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let finalIsim = isim.isEmpty ? "Cihaz" : isim
        tamamlandi?(finalIsim, seciliIkon)
        kapat()
    }
}

// MARK: - CollectionView
extension DeviceNameIconViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ikonlar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IkonHucresi", for: indexPath) as! IkonHucresi
        let ikon = ikonlar[indexPath.item]
        cell.yapilandir(ikon: ikon, secili: ikon == seciliIkon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seciliIkon = ikonlar[indexPath.item]
        collectionView.reloadData()
    }
}

// MARK: - İkon Hücresi
class IkonHucresi: UICollectionViewCell {
    
    private let emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        emojiLabel.font = .systemFont(ofSize: 24)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func yapilandir(ikon: String, secili: Bool) {
        emojiLabel.text = ikon
        backgroundColor = secili ? Tema.Renk.ana : Tema.Renk.kartArkaPlan
        layer.borderWidth = secili ? 0 : 0.5
        layer.borderColor = Tema.Renk.kenarlik.cgColor
    }
}
