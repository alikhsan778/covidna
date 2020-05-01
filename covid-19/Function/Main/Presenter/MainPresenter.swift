//
//  MainPresenter.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorInputProtocol?
    var wireFrame: MainWireFrameProtocol?

    func getCountry() {
        interactor?.getCountry()
    }
    
    func getCoronaData() {
        interactor?.getCoronaData()
    }
    
    func getCoronaDataForChart(country: String, dateFrom: String?, dateTo: String?) {
        var startDate = dateFrom ?? ""
        var endDate = dateTo ?? ""
        if dateFrom == nil && dateTo == nil {
            let toDate = DateHelper.getCurrentDate()
            let fromDate = DateHelper.addDaytoDate(date: toDate, day: -7)
            endDate = DateHelper.convertDatetoString(date: toDate, pattern: DatePattern.medium)
            startDate = DateHelper.convertDatetoString(date: fromDate, pattern: DatePattern.medium)
        }
        interactor?.getCoronaDataForChart(country: country, dateFrom: startDate, dateTo: endDate)
    }
    
    func openCountryForm(from view: UIViewController, countries: [Country]) {
        wireFrame?.openCountryForm(from: view, countries: countries)
    }
    
    func getIndonesianProvinceData() {
        interactor?.getIndonesianProvinceData()
    }
    
    func getIndonesianData() {
        interactor?.getIndonesianData()
    }
    
    func openInternetConnectionForm() {
        wireFrame?.openInternetConnectionForm()
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    
    func processGetCountry(response: [Country]) {
        var countries: [Country] = [Country(Country: "Global", Slug: "Global", ISO2: "")]
        countries += response
        view?.displayCountry(countries: countries)
    }
    
    func processGetCoronaData(response: ResponseCase) {
        view?.displayCoronaData(data: response)
    }
    
    func processCoronaDataForChart(data: [CountryCase], dateFrom: String, dateTo: String) {
        let countryCases = self.dataForChart(data: data)
        view?.displayCoronaDataChart(data: countryCases, dateFrom: dateFrom, dateTo: dateTo)
    }
    
    func errorHandling(processType: ProcessType) {
        view?.errorHandling(type: processType)
    }
    
    private func dataForChart(data: [CountryCase]) -> [CountryCase] {
        var countryCases: [CountryCase] = []
        var isHasProvince = false
        
        if data.count > 0 {
            isHasProvince = !((data[0].Province ?? "").elementsEqual(""))
        }
        
        if isHasProvince {
            data.forEach { (dataCase) in
                var isSameDate = false
                for (index, element) in countryCases.enumerated() {
                    if (element.Date ?? "").elementsEqual(dataCase.Date ?? "") {
                        var updateCountry = element
                        updateCountry.Confirmed = (updateCountry.Confirmed ?? 0) + (dataCase.Confirmed ?? 0)
                        updateCountry.Recovered = (updateCountry.Recovered ?? 0) + (dataCase.Recovered ?? 0)
                        updateCountry.Deaths = (updateCountry.Deaths ?? 0) + (dataCase.Deaths ?? 0)
                        countryCases[index] = updateCountry
                        isSameDate = true
                        break
                    }
                }
                if !isSameDate {
                    countryCases.append(dataCase)
                }
            }
        } else {
            countryCases = data
        }
                
        return countryCases
    }
    
    func processIndonesianProvinceData(response: [AttributeProvince]) {
        let provinces = self.getProvinces(data: response)
        view?.displayIndonesianProvinceData(data: response, provinces: provinces)
    }

    private func getProvinces(data: [AttributeProvince]) -> [Province] {
        var provinces: [Province] = [Province(id: 0, name: "All")]
        for province in data {
            if let kode = province.attributes?.Kode_Provi, let name = province.attributes?.Provinsi {
                let provinsi = Province(id: kode, name: name)
                provinces.append(provinsi)
            }
        }
        return provinces
    }
    
    func processIndonesianData(response: [IndonesiaCoronaData]) {
        if response.count > 0 {
            self.view?.displayIndonesianData(data: response[0])
        } else {
            self.view?.errorHandling(type: .indonesianState)
        }
    }
    
    func openCalendarForm(selectedStartDate: Date, selectedEndDate: Date) {
        wireFrame?.openCalendarForm(selectedStartDate: selectedStartDate, selectedEndDate: selectedEndDate)
    }
}
