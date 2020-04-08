//
//  SWViewControllerService.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol SWViewControllerServiceType {
    func getData(_ coord: SWCoordinate) -> Observable<SWNetworkEvent<SWWeatherDataModel>>
}

struct SWViewControllerService: SWViewControllerServiceType {
    private let provider: SWMoyaProvider<SWViewControllerTarget>

    init() {
        provider = SWMoyaProvider<SWViewControllerTarget>()
    }

    init(provider: SWMoyaProvider<SWViewControllerTarget>) {
        self.provider = provider
    }

    func getData(_ coord: SWCoordinate) -> Observable<SWNetworkEvent<SWWeatherDataModel>> {
        return provider.rx.request(.getData(coord))
            .parseResponse({ (responseString: String) in
                guard var response = SWWeatherDataModel.deserialize(from: responseString) else {
                    var model = SWWeatherDataModel()
                    model.responseString = responseString
                    return model
                }

                response.status = .success
                response.responseString = responseString

                return response
            })
            .mapFailures { error in
                return .failed(error)
            }
    }
}
