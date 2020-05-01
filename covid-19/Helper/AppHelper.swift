//
//  AppHelper.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

class AppHelper {
    
    private init(){}
    
    static func toCurrencyFormat(data: NSNumber) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "id_ID")
        currencyFormatter.currencySymbol = ""
        return currencyFormatter.string(from: data)
    }
 
}
