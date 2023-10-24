//
//  Country.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

struct Country: Codable {
    let name: Name
    let flags: Flags
    let currencies: [String: CurrencyInfo]?
}

struct CurrencyInfo: Codable {
       let name: String?
       let symbol: String?
   }

struct Name: Codable {
    let common: String
}


struct Flags: Codable {
    let png: String
}
