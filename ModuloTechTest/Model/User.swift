//
//  User.swift
//  ModuloTechTest
//
//  Created by Daniel Ghrenassia on 12/02/2020.
//  Copyright © 2020 Daniel Ghrenassia. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let address: Adress
    let birthDate: Int
}

struct Adress: Codable {
    let city: String
    let postalCode: Int
    let street: String
    let streetCode: String
    let country: String
}
