//
//  SummaryCountryCase.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

struct SummaryCountryCase: Codable {
    var Country: String?
    var CountryCode: String?
    var Slug: String?
    var NewConfirmed: UInt?
    var TotalConfirmed: UInt?
    var NewDeaths: UInt?
    var TotalDeaths: UInt?
    var NewRecovered: UInt?
    var TotalRecovered: UInt?
    var Date: String?
}
