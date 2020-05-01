//
//  InternetConnectionRouter.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

class InternetConnectionRouter: InternetConnectionRouterProtocol {
    
    static func presentMainModule(from view: UIViewController) -> UIViewController {
        let viewController = R.storyboard.internetConnection.internetConnectionViewController()
        viewController?.delegate = view as? InternetConnectionDelegate
        viewController?.providesPresentationContextTransitionStyle = true
        viewController?.definesPresentationContext = true
        return viewController!
    }
}
