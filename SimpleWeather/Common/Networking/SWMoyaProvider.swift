//
//  SWMoyaProvider.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya

class SWMoyaProvider<T>: MoyaProvider<T> where T: TargetType {
    override init(endpointClosure: @escaping MoyaProvider<T>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                  requestClosure: @escaping MoyaProvider<T>.RequestClosure = MoyaProvider<T>.defaultRequestMapping,
                  stubClosure: @escaping MoyaProvider<T>.StubClosure = MoyaProvider.neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  manager: Manager = MoyaProvider<T>.defaultAlamofireManager(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        var appendedPlugins = plugins
        let networkLogEnabled = true
        let showNetworkResponse = false
        let cURLEnabled = false

        if _isDebugAssertConfiguration() && networkLogEnabled {
            appendedPlugins.append(NetworkLoggerPlugin(verbose: showNetworkResponse, cURL: cURLEnabled))
        }

        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   manager: manager,
                   plugins: appendedPlugins,
                   trackInflights: trackInflights)
    }
}
