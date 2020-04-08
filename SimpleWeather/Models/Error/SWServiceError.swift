//
//  SWServiceError.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

enum SWResponseStatus: String {
    case success
    case failure
}

struct SWServiceError {
    var responseString: String?
    var status: SWResponseStatus
    var error: MoyaError?

    init() {
        status = .failure
        error = nil
        responseString = nil
    }
}

extension SWServiceError: Equatable {
    public static func == (lhs: SWServiceError, rhs: SWServiceError) -> Bool {
        return lhs.responseString == rhs.responseString &&
            lhs.status == rhs.status
    }
}
