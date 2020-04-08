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

class SWViewControllerService: SWViewControllerServiceType {
    private let provider: SWMoyaProvider<SWViewControllerTarget>

    init() {
        provider = SWMoyaProvider<SWViewControllerTarget>()
    }

    init(provider: SWMoyaProvider<SWViewControllerTarget>) {
        self.provider = provider
    }

    func getData(_ coord: SWCoordinate) -> Observable<SWNetworkEvent<SWWeatherDataModel>> {
        return provider.rx.request(.getData(coord))
            .parseResponse({ [weak self] (responseString: String) in
                guard let `self` = self,
                    var response = SWWeatherDataModel.deserialize(from: responseString) else {
                    var model = SWWeatherDataModel()
                    model.responseString = responseString
                    return model
                }

                response.status = .success
                response.responseString = responseString
                response.requestTime = self.getCurrentDateString()

                return response
            })
            .mapFailures { error in
                return .failed(error)
            }
    }

    private func getCurrentDateString() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: date)
       return formattedDate
    }
}
