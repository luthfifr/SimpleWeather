//
//  SWWeatherDataModel.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

struct SWWeatherDataModel: HandyJSON {
    var responseString: String?
    var status: SWResponseStatus
    var moyaError: MoyaError?

    var coord: SWCoordinate?
    var weather: [SWWeather]?
    var base: String?
    var main: SWMain?
    var visibility: Int?
    var wind: SWWind?
    var clouds: SWCoulds?
    var changes: Int?
    var system: [String: Any]?
    var timezone: Int?
    var reqID: Int?
    var name: String?
    var cod: String?
    var requestTime: String? //added this field to mark the request time

    mutating func mapping(mapper: HelpingMapper) {
        mapper <<< self.changes <-- "dt"
        mapper <<< self.system <-- "sys"
        mapper <<< self.reqID <-- "id"
    }

    init() {
        status = .failure
        moyaError = nil
        responseString = nil
    }

    struct SWWeather: HandyJSON {
        var weatherID: Int?
        var main: String?
        var description: String?
        var icon: String?

        mutating func mapping(mapper: HelpingMapper) {
            mapper <<< self.weatherID <-- "id"
        }
    }

    struct SWMain: HandyJSON {
        var temp: Double?
        var feelsLike: Double?
        var tempMin: Double?
        var tempMax: Double?
        var pressure: Double?
        var humidity: Double?

        mutating func mapping(mapper: HelpingMapper) {
            mapper <<< self.feelsLike <-- "feels_like"
            mapper <<< self.tempMin <-- "temp_min"
            mapper <<< self.tempMax <-- "temp_max"
        }
    }

    struct SWWind: HandyJSON {
        var speed: Double?
        var deg: Double?
    }

    struct SWCoulds: HandyJSON {
        var all: Double?
    }

    struct SWSys: HandyJSON {
        var type: Int?
        var systemID: Int?
        var country: String?
        var sunrise: Double?
        var sunset: Double?

        mutating func mapping(mapper: HelpingMapper) {
            mapper <<< self.systemID <-- "id"
        }
    }
}

struct SWCoordinate: HandyJSON {
    var lat: Double?
    var lon: Double?
}
