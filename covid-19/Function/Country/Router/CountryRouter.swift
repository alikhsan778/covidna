//
//  CountryRouter.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

class CountryRouter: CountryRouterProtocol {
    
    class func assembleModule(from parentView: UIViewController, countries: [Country]) -> UIViewController {
        
        // Generating module components
        let view = R.storyboard.country.countryViewController()
        let presenter = CountryPresenter(countries: countries)
        // Connecting
        view?.presenter = presenter
        view?.delegate = parentView as? CountryViewControllerDelegate
        presenter.view = view
        let navigationController = UINavigationController(rootViewController: view!)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.providesPresentationContextTransitionStyle = true
        navigationController.definesPresentationContext = true

        return navigationController
    }
}
