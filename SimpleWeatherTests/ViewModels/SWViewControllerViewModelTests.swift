//
//  SWViewControllerViewModelTests.swift
//  SimpleWeatherTests
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import XCTest
import RxSwift

@testable import SimpleWeather

class SWViewControllerViewModelTests: XCTestCase {

    private var viewModel: SWViewControllerViewModel!
    private var service: SWViewControllerService!
    private var fakeProvider: SWMockRxMoyaProvider<SWViewControllerTarget>!

    let disposeBag = DisposeBag()

    override func setUp() {
        fakeProvider = SWMockRxMoyaProvider<SWViewControllerTarget>()
        service = SWViewControllerService(provider: fakeProvider)
        viewModel = SWViewControllerViewModel(service: service)
    }

    func testGetDataSuccess() {
        var events: [SWViewControllerViewModelEvent] = []

        events = SWObservableUtilities
            .events(from: viewModel.uiEvents.asObservable(),
                    disposeBag: disposeBag) { [weak self] in
                                                guard let `self` = self else { return }
                                                let coord = SWCoordinate(lat: -6.9,
                                                lon: 107.65)
                                                self.viewModel
                                                    .viewModelEvents
                                                    .onNext(.testWeatherAPICall(coord))
                                                self.fakeProvider.statusCode.onNext(200)
        }.compactMap { $0.value.element }

        XCTAssertTrue(events.contains(.getDataSuccess))
    }

    func testGetDataFailure() {
        var events: [SWViewControllerViewModelEvent] = []

        events = SWObservableUtilities
            .events(from: viewModel.uiEvents.asObservable(),
                    disposeBag: disposeBag) { [weak self] in
                                                guard let `self` = self else { return }
                                                let coord = SWCoordinate(lat: -6.9,
                                                lon: 107.65)
                                                self.viewModel
                                                    .viewModelEvents
                                                    .onNext(.testWeatherAPICall(coord))
                                                self.fakeProvider.statusCode.onNext(404)
        }.compactMap { $0.value.element }

        XCTAssertTrue(events.contains(.getDataFailure(nil)))
    }

    func testReachability() {
        let coord = SWCoordinate(lat: -6.9, lon: 107.65)
        viewModel
            .viewModelEvents
            .onNext(.testWeatherAPICall(coord))
        XCTAssertTrue(viewModel.isOnline)
    }

}
