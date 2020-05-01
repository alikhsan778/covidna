//
//  CountryService.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import RxSwift

class APICountry: APIManager {
    
    static func getCountry() -> Observable<[Country]> {
        return call(object: [Country].self, url: "\(EndPoint.baseUrlGlobal)/countries", parameter: [:])
    }
}
