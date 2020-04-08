//
//  SWMockRxMoyaProvider.swift
//  SimpleWeatherTests
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

@testable import SimpleWeather

final class SWMockRxMoyaProvider<T: TargetType>: SWMoyaProvider<T> {
    private let disposeBag = DisposeBag()

    public var statusCode = PublishSubject<Int>()
    public var response = PublishSubject<Response>()
    public var errorResponse = PublishSubject<Data>()

    public var targetArgument: T!

    public override func request(_ target: T,
                                 callbackQueue: DispatchQueue?,
                                 progress: ProgressBlock?,
                                 completion: @escaping Completion) -> Cancellable {
        targetArgument = target

        statusCode
            .map {
                let data = $0 == 200 ? target.sampleData : self.getErrorData()

                return Response(statusCode: $0, data: data)
            }
            .bind(to: response)
            .disposed(by: disposeBag)

        errorResponse
            .map {
                return Response(statusCode: 500, data: $0)
            }
            .bind(to: response)
            .disposed(by: disposeBag)

        response
            .subscribe(onNext: { completion(.success($0)) })
            .disposed(by: disposeBag)

        return CancellableToken(action: {})
    }

    private func getErrorData() -> Data {
        return Data("{\"message\": \"Server error\"}".data(using: .utf8)!)
    }
}
