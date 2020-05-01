//
//  InternetConnectionContract.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

protocol InternetConnectionDelegate {
    func reload()
}

protocol InternetConnectionRouterProtocol {
    
    static func presentMainModule(from view: UIViewController) -> UIViewController
    
}
