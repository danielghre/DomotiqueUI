//
//  ContainerTableTableViewController.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 12/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import UIKit

class ContainerTableTableViewController: UITableViewController {
    
    var device: Device?

    @IBOutlet weak var onOffButton: UISwitch!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var positionSlider: UISlider!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempSlider: UISlider!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensitySlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = device?.deviceName
        
        switch device?.mode {
        case "ON":
            onOffButton.isOn = true
        case "OFF":
            onOffButton.isOn = false
        default:
            print("no mode")
        }
        
        if let strPosition = device?.position {
            positionSlider.setValue(Float(strPosition), animated: true)
            positionLabel.text = String(strPosition)
        }
        
        if let strTemp = device?.temperature {
            tempSlider.setValue(Float(strTemp), animated: true)
            tempLabel.text = String(strTemp)
        }
        
        if let strIntensity = device?.intensity {
            intensitySlider.setValue(Float(strIntensity), animated: true)
            intensityLabel.text = String(strIntensity)
        }
    }

    @IBAction func positionChanged(_ sender: UISlider) {
        positionLabel.text = String(Int(sender.value))
    }
    
    @IBAction func tempChanged(_ sender: UISlider) {
        tempLabel.text = String(Int(sender.value))
    }
    
    @IBAction func intensityChanged(_ sender: UISlider) {
        intensityLabel.text = String(Int(sender.value))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        Hide row if product doesn't conform to it's mode position temperature or intensity
        if device?.mode == nil {
            if indexPath.section == 0 {
                return 0
            }
        }

        if device?.position == nil {
            if indexPath.section == 1 {
                return 0
            }
        }

        if device?.temperature == nil {
            if indexPath.section == 2 {
                return 0
            }
        }

        if device?.intensity == nil {
            if indexPath.section == 3 {
                return 0
            }
        }

        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
