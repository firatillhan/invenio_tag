//
//  DeviceListViewController.swift
//  invenio_tag
//
//  Created by Fırat İlhan on 16.06.2026.
//

import UIKit


class DeviceListViewController: UIViewController {
    
    @IBOutlet weak var headerLabelSol: UILabel!
    @IBOutlet weak var headerLabelSag: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var devices: [DeviceModel] = []
    private let viewModel = CihazTakipViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tema.Renk.arkaPlan
        setupHeader()
        setupTableView()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        veriYukle()
        viewModel.taramayiBaslat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.taramayiDurdur()
    }
    
    
    private func setupHeader() {
        headerLabelSol.font = Tema.Font.etiket(11)
        headerLabelSol.textColor = Tema.Renk.ucuncuMetin
        
        headerLabelSag.font = Tema.Font.etiket(11)
        headerLabelSag.textColor = Tema.Renk.ana
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    }
    
    private func veriYukle() {
        devices = DeviceStorage.shared.allDevices()
        headerLabelSol.text = "TÜM CİHAZLAR"
        headerLabelSag.text = "\(devices.count) ADET"
        
        if devices.isEmpty {
            if tableView.backgroundView == nil {
                let label = UILabel()
                label.text = "Ekli cihaz yok"
                label.textColor = Tema.Renk.ucuncuMetin
                label.font = Tema.Font.govde(15)
                label.textAlignment = .center
                tableView.backgroundView = label
            }
        } else {
            tableView.backgroundView = nil
        }

        
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cihazDetayinaGit",
           let detayVC = segue.destination as? DeviceDetailViewController,
           let secilenIndexPath = tableView.indexPathForSelectedRow {
            let secilenCihaz = devices[secilenIndexPath.row]
            detayVC.cihaz = secilenCihaz

        }
    }
    
    
}

// MARK: - TableView
extension DeviceListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceListTableViewCell
        let device = devices[indexPath.row]
        let rssi = viewModel.canliRSSI[device.id]
        let bagli = viewModel.bagliMi(id: device.id)
        let canliSonGorulme = viewModel.canliGorulme[device.id]
        cell.yapilandir(device: device, rssi: rssi, bagli: bagli, canliSonGorulme: canliSonGorulme)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cihazDetayinaGit", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension DeviceListViewController: CihazTakipViewModelDelegate {
    func cihazlarGuncellendi() {
        tableView.reloadData()
    }
}



