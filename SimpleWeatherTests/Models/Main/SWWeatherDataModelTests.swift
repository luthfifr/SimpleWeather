//
//  SWWeatherDataModelTests.swift
//  SimpleWeatherTests
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import XCTest

@testable import SimpleWeather

class SWWeatherDataModelTests: XCTestCase {
    private lazy var responseData: SWWeatherDataModel = { [unowned self] in
        let response = SWSampleLoader.loadResponse(file: "weather-currentLocation-sampleResponse")
        if let responseStr = String(data: response, encoding: .utf8),
            var model = SWWeatherDataModel.deserialize(from: responseStr) {
            model.status = .success
            model.responseString = responseStr
            return model
        }
        return SWWeatherDataModel()
    }()

    func testResponseString() {
        XCTAssertNotNil(responseData.responseString)
    }

    func testStatus() {
        XCTAssertTrue(responseData.status == .success)
    }

    func testChangesField() {
        XCTAssertEqual(responseData.changes ?? 0, 1586334971)
    }

    func testSystemField() {
        XCTAssertNotNil(responseData.system)
    }

    func testRequestID() {
        XCTAssertNotNil(responseData.reqID)
    }

    func testTempratures() {
        guard let main = responseData.main else { return }
        XCTAssertEqual(main.feelsLike ?? 0, 300.36)
        XCTAssertEqual(main.tempMin ?? 0, 298.42)
        XCTAssertEqual(main.tempMax ?? 0, 298.42)
    }

}
