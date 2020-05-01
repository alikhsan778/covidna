//
//  APIManager.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Alamofire
import RxSwift

typealias Parameters = [String: Any]

class APIManager {
    
    static func call<T: Codable>(object: T.Type, url: String, parameter : Parameters) -> Observable<T> {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 5
        return Observable<T>.create({ (observer) -> Disposable in
            let request = manager.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: nil)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? FailureReason.notFound)
                            return
                        }
                        do {
                            let response = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(response)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create(with: {
                request.cancel()
            })
        })
    }
}
