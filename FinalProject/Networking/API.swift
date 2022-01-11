//
//  API.swift
//  FinalProject
//
//  Created by Amani Atiah on 15/05/1443 AH.
//

import Foundation
import Alamofire

class API {
    static let baseURL = "https://dummyapi.io/data/v1"
    static let appId = "61dce1739f7084c707755e09"
    static let headers: HTTPHeaders = [
        "app-id": appId
    ]
}
