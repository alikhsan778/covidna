//
//  CountryCase.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

struct CountryCase: Codable {
    var Active: UInt?
    var City: String?
    var CityCode: String?
    var Confirmed: UInt?
    var Country: String?
    var CountryCode: String?
    var Date: String?
    var Deaths: UInt?
    var Lat: String?
    var Lon: String?
    var Province: String?
    var Recovered: UInt?
}
