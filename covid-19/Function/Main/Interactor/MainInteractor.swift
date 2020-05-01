//
//  MainInteractor.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation
import RxSwift

class MainInteractor: MainInteractorInputProtocol {
    
    weak var presenter: MainInteractorOutputProtocol?
    private var disposeBag = DisposeBag()

    func getCountry() {
        APICountry.getCountry()
        .subscribe(onNext: { (response) in
            self.presenter?.processGetCountry(response: response)
        }, onError: { (error) in
            print("terjadi kesalahan pada saat get country")
            self.presenter?.errorHandling(processType: .country)
        }).disposed(by: disposeBag)
    }
    
    func getCoronaData() {
        APICoronaData.getCoronaData()
        .subscribe(onNext: { (response) in
            self.presenter?.processGetCoronaData(response: response)
        }, onError: { (error) in
            print("terjadi kesalahan pada saat get corona data")
            self.presenter?.errorHandling(processType: .coronaData)
        }).disposed(by: disposeBag)
    }
    
    func getCoronaDataForChart(country: String, dateFrom: String, dateTo: String) {
        let urlReqest = "\(country)?from=\(dateFrom)T00:00:00Z&to=\(dateTo)T00:00:00Z"
        APICoronaData.getDataForChart(date: urlReqest)
        .subscribe(onNext: { (response) in
            self.presenter?.processCoronaDataForChart(data: response, dateFrom: dateFrom, dateTo: dateTo)
        }, onError: { (error) in
            self.presenter?.errorHandling(processType: .coronaDataChart)
        }).disposed(by: disposeBag)
    }
    
    func getIndonesianProvinceData() {
        APICoronaData.getIndonesiaProvinceCoronaData()
        .subscribe(onNext: { (response) in
            self.presenter?.processIndonesianProvinceData(response: response)
        }, onError: { (error) in
            print("terjadi kesalahan pada saat get indonesian province data")
            self.presenter?.errorHandling(processType: .provinceIndonesia)
        }).disposed(by: disposeBag)
    }
    
    func getIndonesianData() {
        APICoronaData.getLiveIndonesiaCoronaData()
        .subscribe(onNext: { (response) in
            self.presenter?.processIndonesianData(response: response)
        }, onError: { (error) in
            self.presenter?.errorHandling(processType: .indonesianState)
        }).disposed(by: disposeBag)
    }
}
