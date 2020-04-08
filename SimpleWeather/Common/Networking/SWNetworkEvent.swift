//
//  SWNetworkEvent.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum SWNetworkEvent<ResponseType> {
    case waiting
    case succeeded(ResponseType)
    case failed(SWServiceError)
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func parseResponse<T>(_ parse: @escaping (String) throws -> T) -> Observable<SWNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            let responseString = String(data: response.data, encoding: String.Encoding.utf8)!

            return try parse(responseString)
        })
    }

    func parseDataResponse<T>(_ parse: @escaping (Data) throws -> T) -> Observable<SWNetworkEvent<T>> {
        return parseResponse({ (response: Response) in
            return try parse(response.data)
        })
    }

    func parseResponse<T>(_ parse: @escaping (Response) throws -> T) -> Observable<SWNetworkEvent<T>> {
        return self
            .map { response -> SWNetworkEvent<T> in
                if response.is2xx() {
                    do {
                        return try .succeeded(parse(response))
                    } catch let error {
                        var serviceError = SWServiceError()
                        serviceError.responseString = error.localizedDescription

                        return .failed(serviceError)
                    }
                } else {
                    guard let responseString = String(data: response.data, encoding: String.Encoding.utf8) else {
                        return .failed(SWServiceError())
                    }

                    var serviceError = SWServiceError()
                    serviceError.status = .failure
                    serviceError.responseString = responseString

                    return .failed(serviceError)
                }
            }
            .asObservable()
            .startWith(.waiting)
    }
}

extension Observable where Element == SWNetworkEvent<Any> {
    func mapFailures<T>(_ failure: @escaping (SWServiceError) -> SWNetworkEvent<T>) -> Observable<SWNetworkEvent<T>> {
        return self
            .map { event -> SWNetworkEvent<T> in
                switch event {
                case .succeeded(let val):
                    guard let tval = val as? T else {
                        let serviceError = SWServiceError()
                        return .failed(serviceError)
                    }

                    return .succeeded(tval)

                case .waiting:
                    return .waiting

                case .failed(let error):
                    return failure(error)
                }
            }
    }
}

extension SWNetworkEvent: Equatable {
    public static func == (lhs: SWNetworkEvent, rhs: SWNetworkEvent) -> Bool {
        switch (lhs, rhs) {
        case (.waiting, .waiting):
            return true

        case (.succeeded, .succeeded):
            return true

        case (.failed(let errorLHS), .failed(let errorRHS)):
            return errorLHS == errorRHS

        default:
            return false
        }
    }
}
