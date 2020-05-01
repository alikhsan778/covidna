//
//  CountryContract.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

protocol CountryRouterProtocol: class {
    static func assembleModule(from parentView: UIViewController, countries: [Country]) -> UIViewController
}

protocol CountryPresenterProtocol: class {
    func didLoad()
}

protocol CountryViewProtocol: class {
    func displayData(countries: [Country])
}
