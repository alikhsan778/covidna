//
//  ViewController.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit
import SkeletonView
import Network

class MainViewController: UIViewController {
    var presenter: MainPresenterProtocol?
    
    //MARK: Components
    @IBOutlet weak var countryStackView: UIStackView!
    @IBOutlet weak var textFieldCountry: UITextField!
    @IBOutlet weak var textFieldProvince: UITextField!
    @IBOutlet weak var labelNumberOfPositif: UILabel!
    @IBOutlet weak var labelRecovered: UILabel!
    @IBOutlet weak var labelDeath: UILabel!
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var labelNumberPositifChart: UILabel!
    @IBOutlet weak var leadingLabelPositifChart: NSLayoutConstraint!
    @IBOutlet weak var labelNumberRecoveredChart: UILabel!
    @IBOutlet weak var leadingLabelRecoveredChart: NSLayoutConstraint!
    @IBOutlet weak var labelNumberDeathChart: UILabel!
    @IBOutlet weak var leadingLabelDeathChart: NSLayoutConstraint!
    @IBOutlet weak var labelCountryNameChart: UILabel!
    @IBOutlet weak var labelSelectedDateChart: UILabel!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var positifView: UIView!
    @IBOutlet weak var recoveredView: UIView!
    @IBOutlet weak var deathView: UIView!
    @IBOutlet weak var viewProvince: UIView!
    
    var totalPositif:UInt = 0, totalRecovered:UInt = 0, totalDeath:UInt = 0
    var countries: [Country] = []
    var globalCase: GlobalCase?
    var countryCase: [SummaryCountryCase] = []
    lazy var provinces: [Province] = []
    lazy var indonesianProvinceCase: [AttributeProvince] = []
    
    //MARK: Picker View
    lazy var pickerViewProvince = UIPickerView()
    lazy var selectedProvinceIndex = 0
    lazy var selectedCountrySlug = "indonesia"
    lazy var selectedStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    lazy var selectedEndDate = Date()
    
    fileprivate var leadingMarginInitialPositifConstant: CGFloat!
    fileprivate var leadingMarginInitialRecoveredConstant: CGFloat!
    fileprivate var leadingMarginInitialDeathConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewCalendar.showAnimatedGradientSkeleton()
        self.setConstantLabelChart()
        self.getCountry()
        self.getCoronaData()
        self.getCoronaDataForChart(country: selectedCountrySlug, dateFrom: nil, dateTo: nil)
        chart.delegate = self
        self.setupGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkingInternetConnection()
    }
    
    private func setConstantLabelChart() {
        self.leadingMarginInitialPositifConstant = self.leadingLabelPositifChart.constant
        self.leadingMarginInitialRecoveredConstant = self.leadingLabelRecoveredChart.constant
        self.leadingMarginInitialDeathConstant = self.leadingLabelDeathChart.constant
    }
    
    private func getCountry() {
        self.countryStackView.showAnimatedGradientSkeleton()
        self.presenter?.getCountry()
    }
    
    private func getCoronaData() {
        if self.globalCase == nil || self.countryCase.count == 0 {
            self.setupLoadingTotalView(isShowLoading: true)
            self.presenter?.getCoronaData()
        }
    }
    
    //MARK: Chart
    private func getCoronaDataForChart(country: String, dateFrom: String?, dateTo: String?) {
        self.chart.showAnimatedGradientSkeleton()
        self.setupLoadingChartNumber(isShowLoading: true)
        self.presenter?.getCoronaDataForChart(country: country, dateFrom: dateFrom, dateTo: dateTo)
    }
    
    func checkingInternetConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status != .satisfied {
                DispatchQueue.main.async {
                    self.presenter?.openInternetConnectionForm()
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    private func setupGesture() {
        //open country
        let viewCountryGesture = UITapGestureRecognizer(target: self, action: #selector(openCountry))
        self.countryView.isUserInteractionEnabled = true
        self.countryView.addGestureRecognizer(viewCountryGesture)
        
        //open calendar
        let viewCalendarGesture = UITapGestureRecognizer(target: self, action: #selector(openCalendar))
        self.viewCalendar.isUserInteractionEnabled = true
        self.viewCalendar.addGestureRecognizer(viewCalendarGesture)
    }
    
    @objc func openCountry() {
        presenter?.openCountryForm(from: self, countries: self.countries)
    }
    
    @objc func openCalendar() {
        self.presenter?.openCalendarForm(selectedStartDate: self.selectedStartDate ?? Date(), selectedEndDate: self.selectedEndDate)
    }
    
    private func makeChart(data: [CountryCase]) {
        var xLabelData:[String] = []
        var xLabelIndex: [Double] = []
        var positifData: [Double] = []
        var recoveredData: [Double] = []
        var deathData: [Double] = []
        
        chart.series = []
        for (i, country) in data.enumerated() {
            positifData.append(Double(country.Confirmed ?? 0))
            recoveredData.append(Double(country.Recovered ?? 0))
            deathData.append(Double(country.Deaths ?? 0))
            let date = DateHelper.convertDateToString(date: country.Date ?? "")
            xLabelIndex.append(Double(i))
            xLabelData.append(date)
        }

        chart.lineWidth = 2
        chart.labelFont = UIFont.systemFont(ofSize: 10)
        chart.xLabelsTextAlignment = .left
        chart.xLabels = xLabelIndex
        chart.xLabelsFormatter = { (labelIndex: Int, labelValue: Double) -> String in
            return xLabelData[labelIndex]
        }
        
        let positifSeries = ChartSeries(positifData)
        positifSeries.color = ChartColors.goldColor()
        let recoveredSeries = ChartSeries(recoveredData)
        recoveredSeries.color = ChartColors.greenColor()
        let deathSeries = ChartSeries(deathData)
        deathSeries.color = ChartColors.redColor()
        chart.add([positifSeries, recoveredSeries, deathSeries])
    }
    
    private func setDataLabel(totalPositif: UInt?, totalRecovered: UInt?, totalDeath: UInt?) {
        let positif = (totalPositif ?? 0)
        let positifFormatted = AppHelper.toCurrencyFormat(data: NSNumber(value: positif))
        let recovered = (totalRecovered ?? 0)
        let recoveredFormatted = AppHelper.toCurrencyFormat(data: NSNumber(value: recovered))
        let death = (totalDeath ?? 0)
        let deathFormatted = AppHelper.toCurrencyFormat(data: NSNumber(value: death))
        
        self.labelNumberOfPositif.text = positifFormatted
        self.labelRecovered.text = recoveredFormatted
        self.labelDeath.text = deathFormatted
        self.labelNumberOfPositif.setNeedsDisplay()
        self.labelRecovered.setNeedsDisplay()
        self.labelDeath.setNeedsDisplay()
        self.setupLoadingTotalView(isShowLoading: false)
    }
    
    private func setupProvincePicker() {
        pickerViewProvince.dataSource = self
        pickerViewProvince.delegate = self
        pickerViewProvince.showsSelectionIndicator = true
        let toolBar = self.getToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerProvince))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: true)
        textFieldProvince.text = "All"
        textFieldProvince.inputView = pickerViewProvince
        textFieldProvince.inputAccessoryView = toolBar
    }
    
    private func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func donePickerProvince() {
        self.textFieldProvince.resignFirstResponder()
        let province = self.provinces[selectedProvinceIndex];
        self.textFieldProvince.text = province.name
        if province.id == 0 {
            self.setDataLabel(totalPositif: totalPositif, totalRecovered: totalRecovered, totalDeath: totalDeath)
        } else {
            let provinceData = self.indonesianProvinceCase.first { (attribute) -> Bool in
                attribute.attributes?.Kode_Provi == province.id
            }
            self.setDataLabel(totalPositif: provinceData?.attributes?.Kasus_Posi, totalRecovered: provinceData?.attributes?.Kasus_Semb, totalDeath: provinceData?.attributes?.Kasus_Meni)
        }
    }
    
    private func setupLoadingTotalView(isShowLoading: Bool) {
        [self.positifView, self.recoveredView, self.deathView].forEach {
            isShowLoading ? $0?.showAnimatedGradientSkeleton() : $0?.hideSkeleton()
        }
    }
    
    private func setupLoadingChartNumber(isShowLoading: Bool) {
        [self.labelNumberPositifChart, self.labelNumberRecoveredChart, self.labelNumberDeathChart].forEach {
            isShowLoading ? $0?.showAnimatedGradientSkeleton() : $0?.hideSkeleton()
        }
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.provinces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedProvinceIndex = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.provinces[row].name
    }
}

extension MainViewController: ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (_, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(0, atIndex: dataIndex) {
                self.labelNumberPositifChart.text = "P: \(value)"
                
                var constant = leadingMarginInitialPositifConstant + left - (self.labelNumberPositifChart.frame.width / 2)
                
                // Avoid placing the label on the left of the chart
                if constant < leadingMarginInitialPositifConstant {
                    constant = leadingMarginInitialPositifConstant
                }
                
                // Avoid placing the label on the right of the chart
                let rightMargin = chart.frame.width - self.labelNumberPositifChart.frame.width
                if constant > rightMargin {
                    constant = rightMargin
                }
                leadingLabelPositifChart.constant = constant
            }
            if let value = chart.valueForSeries(1, atIndex: dataIndex) {
                self.labelNumberRecoveredChart.text = "R: \(value)"
                var constant = leadingMarginInitialRecoveredConstant + left - (self.labelNumberRecoveredChart.frame.width / 2)
                
                // Avoid placing the label on the left of the chart
                if constant < leadingMarginInitialRecoveredConstant {
                    constant = leadingMarginInitialRecoveredConstant
                }
                
                // Avoid placing the label on the right of the chart
                let rightMargin = chart.frame.width - self.labelNumberRecoveredChart.frame.width
                if constant > rightMargin {
                    constant = rightMargin
                }
                leadingLabelRecoveredChart.constant = constant
            }
            if let value = chart.valueForSeries(2, atIndex: dataIndex) {
                self.labelNumberDeathChart.text = "D: \(value)"
                var constant = leadingMarginInitialDeathConstant + left - (self.labelNumberDeathChart.frame.width / 2)
                
                // Avoid placing the label on the left of the chart
                if constant < leadingMarginInitialDeathConstant {
                    constant = leadingMarginInitialDeathConstant
                }
                
                // Avoid placing the label on the right of the chart
                let rightMargin = chart.frame.width - self.labelNumberDeathChart.frame.width
                if constant > rightMargin {
                    constant = rightMargin
                }
                leadingLabelDeathChart.constant = constant
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        self.didFinishTouchingChart()
    }
    
    private func didFinishTouchingChart() {
        self.labelNumberPositifChart.text = "P: 0"
        leadingLabelPositifChart.constant = leadingMarginInitialPositifConstant
        self.labelNumberRecoveredChart.text = "S: 0"
        leadingLabelRecoveredChart.constant = leadingMarginInitialRecoveredConstant
        self.labelNumberDeathChart.text = "M: 0"
        leadingLabelDeathChart.constant = leadingMarginInitialDeathConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
}

extension MainViewController: CalendarDateRangePickerViewControllerDelegate {
    
    func didCancelPickingDateRange() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didPickDateRange(startDate: Date!, endDate: Date!) {
        self.dismiss(animated: true, completion: nil)
        self.selectedStartDate = startDate
        self.selectedEndDate = endDate
        let dateFrom = DateHelper.convertDatetoString(date: startDate, pattern: DatePattern.medium)
        let dateTo = DateHelper.convertDatetoString(date: endDate, pattern: DatePattern.medium)
        self.didFinishTouchingChart()
        self.getCoronaDataForChart(country: selectedCountrySlug, dateFrom: dateFrom, dateTo: dateTo)
    }
}

extension MainViewController: CountryViewControllerDelegate {
    
    func didSelectedCountry(country: Country) {
        self.setupLoadingTotalView(isShowLoading: true)
        self.textFieldCountry.text = country.Country ?? "Global"
        self.labelCountryNameChart.text = ""
        self.didFinishTouchingChart()
        if var slug = country.Slug {
            if slug.elementsEqual("Global") {
                slug = "indonesia"
                self.labelCountryNameChart.text = "Indonesia"
                self.viewProvince.isHidden = true
                self.setDataLabel(totalPositif: self.globalCase?.TotalConfirmed, totalRecovered: self.globalCase?.TotalRecovered, totalDeath: self.globalCase?.TotalDeaths)
            } else {
                if  slug.elementsEqual("indonesia") {
                    if self.provinces.count == 0 {
                        self.presenter?.getIndonesianProvinceData()
                    } else {
                        self.textFieldProvince.text = "All"
                        self.pickerViewProvince.selectRow(0, inComponent: 0, animated: true)
                        self.viewProvince.isHidden = false
                    }
                    self.setupLoadingTotalView(isShowLoading: true)
                    self.presenter?.getIndonesianData()
                } else {
                    self.viewProvince.isHidden = true
                    let countryCase = self.countryCase.first { (item) -> Bool in
                        (item.Slug ?? "").elementsEqual(slug)
                    }
                    self.setDataLabel(totalPositif: countryCase?.TotalConfirmed, totalRecovered: countryCase?.TotalRecovered, totalDeath: countryCase?.TotalDeaths)
                }
            }
            self.selectedStartDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            self.selectedEndDate = Date()
            self.selectedCountrySlug = slug
            self.getCoronaDataForChart(country: slug, dateFrom: nil, dateTo: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainViewController: InternetConnectionDelegate {
    func reload() {
        self.countries = []
        self.getCountry()
        self.getCoronaData()
        self.getCoronaDataForChart(country: selectedCountrySlug, dateFrom: nil, dateTo: nil)
    }
}

extension MainViewController: MainViewProtocol {
    
    func displayCountry(countries: [Country]) {
        self.countries += countries
        self.countryStackView.hideSkeleton()
    }
    
    func displayCoronaData(data: ResponseCase) {
        self.globalCase = data.Global
        self.countryCase = data.Countries ?? []
        self.setDataLabel(totalPositif: self.globalCase?.TotalConfirmed, totalRecovered: self.globalCase?.TotalRecovered, totalDeath: self.globalCase?.TotalDeaths)
        self.setupLoadingTotalView(isShowLoading: false)
    }
    
    func displayCoronaDataChart(data: [CountryCase], dateFrom: String, dateTo: String) {
        self.labelSelectedDateChart.text = "\(dateFrom) to \(dateTo)"
        self.viewCalendar.hideSkeleton()
        self.makeChart(data: data)
        self.chart.hideSkeleton()
        self.setupLoadingChartNumber(isShowLoading: false)
    }
    
    func displayIndonesianProvinceData(data: [AttributeProvince], provinces: [Province]) {
        self.indonesianProvinceCase = data
        self.provinces = provinces
        self.setupProvincePicker()
        self.pickerViewProvince.reloadAllComponents()
        self.viewProvince.isHidden = false
    }
    
    func displayIndonesianData(data: IndonesiaCoronaData) {
        let positif = UInt(data.positif?.replacingOccurrences(of: ",", with: "") ?? "0")
        let recovered = UInt(data.sembuh?.replacingOccurrences(of: ",", with: "") ?? "0")
        let death = UInt(data.meninggal?.replacingOccurrences(of: ",", with: "") ?? "0")
        self.totalPositif = positif ?? 0
        self.totalRecovered = recovered ?? 0
        self.totalDeath = death ?? 0
        self.setDataLabel(totalPositif: positif, totalRecovered: recovered, totalDeath: death)
    }
    
    func errorHandling(type: ProcessType) {
        switch type {
        case .country:
            self.countryStackView.hideSkeleton()
        case .coronaData:
            self.setupLoadingTotalView(isShowLoading: false)
        case .coronaDataChart:
            self.chart.hideSkeleton()
            self.viewCalendar.hideSkeleton()
            self.setupLoadingChartNumber(isShowLoading: false)
        case .provinceIndonesia:
            print("")
        case .indonesianState:
            let countryCase = self.countryCase.first { (item) -> Bool in
                (item.Slug ?? "").elementsEqual("indonesia")
            }
            self.setDataLabel(totalPositif: countryCase?.TotalConfirmed, totalRecovered: countryCase?.TotalRecovered, totalDeath: countryCase?.TotalDeaths)
            self.setupLoadingTotalView(isShowLoading: false)
        }
    }
}
