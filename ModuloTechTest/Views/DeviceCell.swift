//
//  DeviceCell.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 11/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import UIKit

protocol DeviceCellDelegate: class {
    func delete(cell: DeviceCell)
}

class DeviceCell: UICollectionViewCell {
    
    weak var delegate: DeviceCellDelegate?
    
    var productType: String? {
        didSet {
            setupProductCellForType()
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            self.removeButton.alpha = 0
            self.removeButton.isHidden = !isEditing

            UIView.animate(withDuration: 0.3, animations: {
                self.removeButton.alpha = 1
            }, completion: {
                finished in
                self.removeButton.isHidden = !self.isEditing
            })
        }
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let deviceName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let infos: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitle("X", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        removeButton.isHidden = !isEditing
        removeButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        setupViews()
    }
    
    @objc func deletePressed() {
        delegate?.delete(cell: self )
    }
    
    func setupProductCellForType() {
        switch productType {
        case "Light":
            iconImageView.image = #imageLiteral(resourceName: "lamp")
            backgroundColor = UIColor(rgb: 0xe74c3c)
        case "RollerShutter":
            iconImageView.image = #imageLiteral(resourceName: "RollerShutter")
            backgroundColor = UIColor(rgb: 0x9b59b6)
        case "Heater":
            iconImageView.image = #imageLiteral(resourceName: "heater")
            backgroundColor = UIColor(rgb: 0xf39c12)
        default:
            print("no product type found")
        }
    }
    
    func setupViews(){
        layer.cornerRadius = 25
        
        addSubview(iconImageView)
        iconImageView.frame = CGRect(x: 12, y: frame.height / 2 - 25, width: 50, height: 50)
        addSubview(removeButton)
        removeButton.frame = CGRect(x: frame.width - 30, y: 10, width: 20, height: 20)
        
        let stackView = UIStackView(arrangedSubviews: [deviceName, infos])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.frame = CGRect(x: 72, y: frame.height / 2 - 25, width: frame.width - 60, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
