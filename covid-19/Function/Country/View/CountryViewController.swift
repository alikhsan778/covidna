//
//  CountryViewController.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

protocol CountryViewControllerDelegate: class {
    func didSelectedCountry(country: Country)
}

class CountryViewController: UIViewController {

    var presenter: CountryPresenterProtocol?
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var delegate: CountryViewControllerDelegate?
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Country"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let indexPath = tableView.indexPathForSelectedRow {
//          tableView.deselectRow(at: indexPath, animated: true)
//        }
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = self.countries.filter { (country: Country) -> Bool in
            if isSearchBarEmpty {
                return false
            } else {
                return (country.Country ?? "").lowercased().contains(searchText.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredCountries.count
        }
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.countryCell, for: indexPath)!
        let country: Country
        if isFiltering {
          country = filteredCountries[indexPath.row]
        } else {
          country = countries[indexPath.row]
        }
        cell.textLabel?.text = country.Country
        cell.textLabel?.font = UIFont(name: "Avenir Next Bold", size: 14)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        delegate?.didSelectedCountry(country: country)
    }
}

extension CountryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension CountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension CountryViewController: CountryViewProtocol {
    func displayData(countries: [Country]) {
        self.countries = countries
        self.tableView.reloadData()
    }
}
