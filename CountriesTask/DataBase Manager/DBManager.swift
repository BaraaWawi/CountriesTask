//
//  DBManager.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()

    private let db: Connection

    private let countries = Table("countries")
    private let name = Expression<String>("name")
    private let flagURL = Expression<String>("flagURL")
    private let currency = Expression<String>("currency")
    private let currencyCode = Expression<String>("currencyCode")
    
    //MARK: - INIT
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!

        do {
            db = try Connection("\(path)/db.sqlite3")
            createTable()
        } catch {
            fatalError("Error initializing database: \(error)")
        }
    }
    
    //MARK: - CREATE TABLE
    private func createTable() {
        do {
                        
            try db.run(countries.create(ifNotExists : true){ table in
                table.column(name, unique: true)
                table.column(flagURL)
                table.column(currency)
                table.column(currencyCode)
            })
        } catch {
            fatalError("Error creating table: \(error)")
        }
    }
    
    //MARK: - CHECK EMPTY
    func isDatabaseEmpty() -> Bool {
        do {
            let count = try db.scalar(countries.count)
            return count == 0
        } catch {
            return true
        }
    }
    
    //MARK: - INSERT DATA
    func insertCountry(name: String, flagURL: String, currency: String ,currencyCode : String ) {
        let insert = countries.insert(self.name <- name, self.flagURL <- flagURL, self.currency <- currency , self.currencyCode <- currencyCode)
        
        do {
            
            try db.run(insert)
        } catch {
            print("Insert failed: \(error)")
        }
    }
    
    //MARK: - GET DATA
    func getCountries() -> [Country] {
        
        var result = [Country]()
        do {
            
            for country in try db.prepare(countries) {
                
                let currencyObj : [String: CurrencyInfo]? = ["":CurrencyInfo(name: country[currency], symbol: country[currencyCode])]
                
                let countryObject = Country(name: Name(common: country[name]), flags: Flags(png: country[flagURL]), currencies:currencyObj )

                result.append(countryObject)
            }
        } catch {
            print("Select failed: \(error)")
        }
        return result
    }
    
    //MARK: - PRINT DATA
    func printDatabaseContents() {
        do {
            for country in try db.prepare(countries) {
                print("Name: \(country[name]), Flag URL: \(country[flagURL]) Currency: \(country[currency]) Currency Code = \(country[currencyCode])")
            }
        } catch {
            print("Error printing database contents: \(error)")
        }
    }
    
}
