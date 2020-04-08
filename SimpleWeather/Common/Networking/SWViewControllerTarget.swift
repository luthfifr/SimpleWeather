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
    case getData(_ coord: SWCoordinate)
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
        case .getData(let coord):
            return .requestParameters(parameters: getParemeters(coord), encoding: encoding)
        }
    }

    var sampleData: Data {
        switch self {
        case .getData:
            return SWSampleLoader.loadResponse(file: "weather-currentLocation-sampleResponse")
        }
    }

    var headers: [String: String]? {
        return nil
    }
}

extension SWViewControllerTarget {
    private func getParemeters(_ coord: SWCoordinate) -> [String: Any] {
        var params = [String: Any]()

//        params["q"] = "Jakarta,id"
        params["lat"] = coord.lat ?? 0
        params["lon"] = coord.lon ?? 0
        params["appid"] = "e24963a12cdbefaca5b79c9781ac6d1e"

        return params
    }
}
