//
//  ProvinceCoronaData.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

struct ProvinceCoronaData: Codable {
    var FID: UInt?
    var Kode_Provi: UInt?
    var Provinsi: String?
    var Kasus_Posi: UInt?
    var Kasus_Semb: UInt?
    var Kasus_Meni: UInt?
}

struct AttributeProvince: Codable {
    var attributes: ProvinceCoronaData?
}
