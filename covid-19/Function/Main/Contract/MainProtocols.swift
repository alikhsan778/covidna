//
//  MainProtocols.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

protocol MainViewProtocol: class {
    var presenter: MainPresenterProtocol? { get set }

    func displayCountry(countries: [Country])
    
    func displayCoronaData(data: ResponseCase)
    
    func displayCoronaDataChart(data: [CountryCase], dateFrom: String, dateTo: String)
    
    func displayIndonesianProvinceData(data: [AttributeProvince], provinces: [Province])
    
    func displayIndonesianData(data: IndonesiaCoronaData)
    
    func errorHandling(type: ProcessType)
    
}

protocol MainWireFrameProtocol: class {
    static func presentMainModule() -> UIViewController
    
    func openCountryForm(from view: UIViewController, countries: [Country])
    
    func openCalendarForm(selectedStartDate: Date, selectedEndDate: Date)
    
    func openInternetConnectionForm()
}

protocol MainPresenterProtocol: class {
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorInputProtocol? { get set }
    var wireFrame: MainWireFrameProtocol? { get set }
    
    func getCountry()
    
    func getCoronaData()
    
    func getCoronaDataForChart(country: String, dateFrom: String?, dateTo: String?)
    
    func openCountryForm(from view: UIViewController, countries: [Country])
    
    func getIndonesianProvinceData()
    
    func getIndonesianData()
    
    func openCalendarForm(selectedStartDate: Date, selectedEndDate: Date)
    
    func openInternetConnectionForm()
}

protocol MainInteractorInputProtocol: class {
    var presenter: MainInteractorOutputProtocol? { get set }
    
    func getCountry()
    
    func getCoronaData()
    
    func getCoronaDataForChart(country: String, dateFrom: String, dateTo: String)
    
    func getIndonesianProvinceData()
    
    func getIndonesianData()
}

protocol MainInteractorOutputProtocol: class {
    
    func processGetCountry(response: [Country])
    
    func errorHandling(processType: ProcessType)
    
    func processGetCoronaData(response: ResponseCase)
    
    func processCoronaDataForChart(data: [CountryCase], dateFrom: String, dateTo: String)
    
    func processIndonesianProvinceData(response: [AttributeProvince])
    
    func processIndonesianData(response: [IndonesiaCoronaData])
}

