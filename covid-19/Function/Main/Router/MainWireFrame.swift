//
//  MainWireFrame.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit

class MainWireFrame: MainWireFrameProtocol {
    
    weak var viewController: UIViewController?
    
    class func presentMainModule() -> UIViewController {
        
        // Generating module components
        let view = R.storyboard.main.mainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let wireFrame = MainWireFrame()
        // Connecting
        view?.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        wireFrame.viewController = view
        
        return view!
    }
    
    func openCountryForm(from view: UIViewController, countries: [Country]) {
        let view = CountryRouter.assembleModule(from: self.viewController!, countries: countries)
        viewController?.present(view, animated: true, completion: nil)
    }
    
    func openCalendarForm(selectedStartDate: Date, selectedEndDate: Date) {
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = (self.viewController as! CalendarDateRangePickerViewControllerDelegate)
        dateRangePickerViewController.minimumDate = DateHelper.getDateByComponent(day: 1, month: 1, year: 2020)
        dateRangePickerViewController.maximumDate = Date()
        dateRangePickerViewController.selectedStartDate =  selectedStartDate
        dateRangePickerViewController.selectedEndDate = selectedEndDate
        dateRangePickerViewController.selectedColor = UIColor.red
        dateRangePickerViewController.titleText = "Select Date Range"
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func openInternetConnectionForm() {
        let view = InternetConnectionRouter.presentMainModule(from: self.viewController!)
        viewController?.present(view, animated: true, completion: nil)
    }
}
