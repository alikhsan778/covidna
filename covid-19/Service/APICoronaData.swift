//
//  APICoronaData.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import RxSwift

class APICoronaData: APIManager {
    
    static func getLiveIndonesiaCoronaData() -> Observable<[IndonesiaCoronaData]> {
        return call(object: [IndonesiaCoronaData].self, url: "\(EndPoint.baseUrlIndonesia)/indonesia", parameter: [:])
    }
    
    static func getIndonesiaProvinceCoronaData() -> Observable<[AttributeProvince]> {
        return call(object: [AttributeProvince].self, url: "\(EndPoint.baseUrlIndonesia)/indonesia/provinsi", parameter: [:])
    }
    
    static func getDataForChart(date: String) -> Observable<[CountryCase]> {
        return call(object: [CountryCase].self, url: "\(EndPoint.baseUrlGlobal)/country/\(date)", parameter: [:])
    }
    
    static func getCoronaData() -> Observable<ResponseCase> {
        return call(object: ResponseCase.self, url: "\(EndPoint.baseUrlGlobal)/summary", parameter: [:])
    }
    
}
