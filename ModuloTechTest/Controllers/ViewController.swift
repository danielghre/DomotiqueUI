//
//  ViewController.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 11/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var response: Response?
    var devicesArray: [Device]?
    
    @IBOutlet private weak var lightButton: MTButton!
    @IBOutlet private weak var rollerShutterbutton: MTButton!
    @IBOutlet private weak var heaterButton: MTButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func lightPressed(_ sender: MTButton) {
        filter(sender: sender, device: "Light")
    }
    
    @IBAction func rollerPressed(_ sender: MTButton) {
        filter(sender: sender, device: "RollerShutter")
    }
    
    @IBAction func heaterPressed(_ sender: MTButton) {
        filter(sender: sender, device: "Heater")
    }
    
    func filter(sender: MTButton, device: String) {
        if sender.active {
            devicesArray = devicesArray?.filter( {$0.productType != device })
            collectionView.reloadData()
        } else {
            if !lightButton.active {
                devicesArray = (response?.devices.filter({ ($0.productType == "Light") }))!
            }
            if !rollerShutterbutton.active {
                devicesArray! += (response?.devices.filter( {$0.productType == "RollerShutter" }))!
            }
            if !heaterButton.active {
                devicesArray! += (response?.devices.filter( {$0.productType == "Heater" }))!
            }
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        fetchData()
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DeviceCell.self, forCellWithReuseIdentifier: "cellId")
        navigationItem.rightBarButtonItem = editButtonItem
        editButtonItem.tintColor = .label
    }
    
    func fetchData() {
        let urlString = "http://storage42.com/modulotest/data.json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    self.response = try decoder.decode(Response.self, from: data)
                    self.devicesArray = self.response?.devices
                    self.collectionView.reloadData()
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
        }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfilSegue" {
            let navVC = segue.destination as! UINavigationController
            let destinationVC = navVC.viewControllers.first as! ProfilViewController
            destinationVC.user = response?.user
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)  as! DeviceCell
        cell.delegate = self
        cell.deviceName.text = devicesArray?[indexPath.item].deviceName
        cell.productType = (devicesArray?[indexPath.item].productType)!
        cell.infos.text = getInfos(item: indexPath.item)
        return cell
    }
    
    func getInfos(item: Int) -> String {
        var infos = ""
        if let result = devicesArray?[item].mode {
            infos += "Mode: \(result) "
        }
        if let result = devicesArray?[item].intensity {
            infos += "Intensity: \(result) "
        }
        if let result = devicesArray?[item].temperature {
            infos += "Temperature: \(result) "
        }
        if let result = devicesArray?[item].position {
            infos += "Position: \(result) "
        }
        return infos
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let indexPath = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPath {
                if let cell = collectionView.cellForItem(at: indexPath) as? DeviceCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! ContainerTableTableViewController
        controller.device = devicesArray?[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension ViewController: DeviceCellDelegate {
    func delete(cell: DeviceCell) {
        if let indexPath  = collectionView.indexPath(for: cell) {
            devicesArray?.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}
