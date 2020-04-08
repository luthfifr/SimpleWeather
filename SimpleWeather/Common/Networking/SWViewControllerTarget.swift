//
//  SWViewControllerTarget.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

enum SWViewControllerTarget {
    case getData
}

extension SWViewControllerTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .getData:
            return URL(string: "http://api.openweathermap.org") ?? URL(string: "")!
        }
    }

    var path: String {
        switch self {
        case .getData:
            return String("data/2.5/weather")
        }
    }

    var method: Moya.Method {
        return .get
    }

    var encoding: URLEncoding {
        return .queryString
    }

    var task: Task {
        switch self {
        case .getData:
            return .requestParameters(parameters: getParemeters(), encoding: encoding)
        }
    }

    var sampleData: Data {
        switch self {
        case .getData:
            return Data()
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

extension SWViewControllerTarget {
    private func getParemeters() -> [String: Any] {
        var params = [String: Any]()

        params["q"] = "Jakarta,id"
        params["appid"] = "e24963a12cdbefaca5b79c9781ac6d1e"

        return params
    }
}
