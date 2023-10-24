//
//  ViewController.swift
//  CountriesTask
//
//  Created by Baraa Wawi on 22/10/2023.
//

import UIKit

class CountriesViewController: UIViewController {

    //MARK: - Properties & Variables
    @IBOutlet weak var tableView: UITableView!
    private var viewModel = CountryListViewModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchCountries()

    }

    //MARK: - Helpers
    private func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryTableViewCell.countryCellNib, forCellReuseIdentifier: CountryTableViewCell.countryCellId)
    }

    //MARK: - Methods
    private func fetchCountries(){
        
        viewModel.fetchCountries {
        self.tableView.reloadData()
        }
        DatabaseManager.shared.printDatabaseContents()

    }
    
}//end CountriesViewController

//MARK: - UITableViewDataSource
extension CountriesViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountries
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.countryCellId, for: indexPath) as! CountryTableViewCell
            cell.viewModel = viewModel
            cell.loadCell(atIndex: indexPath.row)
        
            return cell
    }
    
}

//MARK: - UITableViewDelegate
extension CountriesViewController : UITableViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == self.tableView{
            if (scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height){
                
                viewModel.setPaginationItems()
                tableView.reloadData()
            }
        }
    }
}
