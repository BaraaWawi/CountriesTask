//
//  CountryService.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import Alamofire


class CountryService {
    static func fetchCountries(completion: @escaping ([Country]?) -> Void) {
        AF.request("https://restcountries.com/v3.1/all").responseDecodable(of: [Country].self) { response in
            print(response)
            guard let countries = response.value else {
                
                completion(nil)
                return
            }
            completion(countries)
        }
    }
}
