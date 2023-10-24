//
//  CountryListViewModel.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import UIKit

class CountryListViewModel {
    
    //MARK: - Variables
    private var countries: [Country] = []
    var itemsPerPage = 15
    var limit = 15
    var paginationRepositories : [Country] = []
    
    // MARK: - Fetching Countries
    
    func fetchCountries(completion: @escaping () -> Void) {

        //Check if database is empty the get the data and save it to database
        if DatabaseManager.shared.isDatabaseEmpty() {
            
            CountryService.fetchCountries { [weak self] fetchedCountries in
                if let countries = fetchedCountries {
                    self?.countries = countries
                    self?.limit = self?.countries.count ?? 1000
                    for i in 0..<15 {
                        self?.paginationRepositories.append(countries[i])
                    }
                    
                    self?.saveCountriesToDatabase(countries)

                    completion()
                }
            }
        } else {
            countries = DatabaseManager.shared.getCountries()

            limit = countries.count
            for i in 0..<15 {
                paginationRepositories.append(countries[i])
            }
            
            completion()
        }
    }
    
    // MARK: - Pagination

    func setPaginationItems(){
        
        print("limit = \(limit)")
        print("((((((((( = \(itemsPerPage)")
        if itemsPerPage >= limit{
            return
        }else if itemsPerPage >= limit - 15{
            for i in itemsPerPage..<limit{
                paginationRepositories.append(countries[i])
            }
            self.itemsPerPage += 15
        }else{
            for i in itemsPerPage..<itemsPerPage + 15{
                paginationRepositories.append(countries[i])
            }
            self.itemsPerPage += 15
        }

    }
    
    
    
    // MARK: - Reading Data
    
    func getCountry(at index: Int) -> (name: String, flagURL: String, currencyName : String?, currencySymbol : String?)? {
        guard index < paginationRepositories.count else {
            return nil
        }
        let country = paginationRepositories[index]
        let currency = country.currencies?.values.first
        
        return (country.name.common, country.flags.png,currency?.name,currency?.symbol )
    }

    var numberOfCountries: Int {
        return paginationRepositories.count
    }


    // MARK: - Database Saving
    
    private func saveCountriesToDatabase(_ countries: [Country]) {
        for country in countries {
            let cur = country.currencies?.values.first
            
            DatabaseManager.shared.insertCountry(name: country.name.common, flagURL: country.flags.png, currency: cur?.name ?? "", currencyCode: cur?.symbol ?? "")
        }
    }
}
