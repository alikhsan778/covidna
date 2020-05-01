//
//  ResponseCase.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

struct ResponseCase: Codable {
    var Global: GlobalCase?
    var Countries: [SummaryCountryCase]?
}
