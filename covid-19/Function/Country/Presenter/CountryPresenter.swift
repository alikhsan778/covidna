//
//  CountryPresenter.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

class CountryPresenter: CountryPresenterProtocol {

    var countries: [Country]
    weak var view: CountryViewProtocol?
    
    init(countries: [Country]) {
        self.countries = countries
    }
    
    func didLoad() {
        view?.displayData(countries: self.countries)
    }
}
