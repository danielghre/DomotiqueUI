//
//  MTButton.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 11/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import UIKit

class MTButton: UIButton {

    private var _active = false
    var active: Bool {
        set {
            _active = newValue
            updateState()
        }
        get {
            return _active
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
    }

    @objc func touchUpInside(sender:UIButton) {
        active = !active
        if active {
            backgroundColor = .clear
            setTitleColor(.label, for: .normal)
        } else {
            backgroundColor = .label
            setTitleColor(.systemBackground, for: .normal)
        }
    }

    private func updateState() {
        OperationQueue.main.addOperation {
            self.isHighlighted = self.active
        }
    }

}
