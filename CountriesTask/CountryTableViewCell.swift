//
//  CountryTableViewCell.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    static let countryCellId = "CountryTableViewCell"
    static let countryCellNib = UINib(nibName: "CountryTableViewCell", bundle: nil)


    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var currencyCodeLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
     var viewModel = CountryListViewModel()
    var imageViewModel = ImageViewModel()
    override func awakeFromNib() {
        
        super.awakeFromNib()

    }
    
    func loadCell(atIndex index : Int){
        
        if let country = viewModel.getCountry(at: index){
            
            if let currName = country.currencyName , let currSymbol = country.currencySymbol{
                currencyLbl.text = "Currency :\(currName)"
                currencyCodeLbl.text = "Currency Code : \(currSymbol)"
            }
            
            nameLbl.text = "Name : \(country.name)"
            
           
                    if let imageUrl = URL(string: country.flagURL) {
                        imageViewModel.loadImage(from: imageUrl) { [weak self] in
                            DispatchQueue.main.async {
                                self?.countryFlag.image = self?.imageViewModel.image
                            }
                        }
                    }
                }
        }
        
    
    
}
