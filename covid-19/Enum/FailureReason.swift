//
//  FailureReason.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}
