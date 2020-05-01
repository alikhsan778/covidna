//
//  InternetConnectionViewController.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import UIKit
import Network

class InternetConnectionViewController: UIViewController {

    var delegate: InternetConnectionDelegate?
    
    @IBOutlet weak var buttonRetry: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkingInternetConnection()
    }
    
    func checkingInternetConnection() {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                DispatchQueue.main.async {
                    self.buttonRetry.isHidden = false
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    @IBAction func retryAction(_ sender: Any) {
        delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        view.setNeedsUpdateConstraints()
    }
    
}
