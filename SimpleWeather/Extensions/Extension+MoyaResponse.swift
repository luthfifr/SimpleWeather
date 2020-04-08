//
//  Extension+MoyaResponse.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

extension Moya.Response {
    public func is2xx() -> Bool {
        if (statusCode >= 200) && (statusCode < 300) { return true }

        return false
    }

    public func isTimedOut() -> Bool {
        return statusCode == 504
    }

    public func parseDataToString() -> String {
        guard let responseString = String(data: data, encoding: String.Encoding.utf8) else { return "" }

        return responseString
    }
}
