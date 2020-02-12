//
//  Devices.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 11/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import Foundation

struct Response: Codable {
    
    var devices: [Device]
    let user: User
}

struct Device: Codable {
    
    let id: Int
    let deviceName: String
    let intensity: Int?
    let mode: String?
    let productType: String
    let position: Int?
    let temperature: Int?
}



