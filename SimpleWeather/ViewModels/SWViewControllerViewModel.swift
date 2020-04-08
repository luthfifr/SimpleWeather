//
//  SWViewControllerViewModel.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import RxSwift

enum SWViewControllerViewModelEvent: Equatable {
    case getData
    case getDataSuccess
    case getDataFailure(_ error: SWServiceError?)

    static func == (lhs: SWViewControllerViewModelEvent, rhs: SWViewControllerViewModelEvent) -> Bool {
        switch (lhs, rhs) {
        case (getData, getData),
             (getDataSuccess, getDataSuccess),
             (getDataFailure, getDataFailure):
            return true
        default: return false
        }
    }
}

protocol SWViewControllerViewModelType {
    var uiEvents: PublishSubject<SWViewControllerViewModelEvent> { get }
    var viewModelEvents: PublishSubject<SWViewControllerViewModelEvent> { get }
    var responseModel: SWWeatherDataModel? { get }
    var isOnline: Bool { get }
}

final class SWViewControllerViewModel: SWViewControllerViewModelType {
    private let disposeBag = DisposeBag()
    private let service: SWViewControllerService!

    let uiEvents = PublishSubject<SWViewControllerViewModelEvent>()
    let viewModelEvents = PublishSubject<SWViewControllerViewModelEvent>()
    var responseModel: SWWeatherDataModel? {
        didSet {
            self.uiEvents.onNext(.getDataSuccess)
        }
    }
    var isOnline = false

    init() {
        self.service = SWViewControllerService()
        setupEvents()
    }

    init(service: SWViewControllerService) {
        self.service = service
        setupEvents()
    }
}

// MARK: - Private methods
extension SWViewControllerViewModel {
    private func setupEvents() {
        viewModelEvents.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .getData:
                self.getData()
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func getData() {
        isOnline = SWReachability.shared.isNetworkAvailable
        if isOnline {
            service
                .getData()
                .asObservable()
                .subscribe(onNext: { [weak self] event in
                    guard let `self` = self else { return }
                    switch event {
                    case .succeeded(let model):
                        self.responseModel = model
                    case .failed(let error):
                        self.uiEvents.onNext(.getDataFailure(error))
                    case .waiting: break
                    }
                }).disposed(by: disposeBag)
        } else {
            let responseData = SWSampleLoader.loadResponse(file: "")
            if let responseStr = String(data: responseData, encoding: .utf8),
                let model = SWWeatherDataModel.deserialize(from: responseStr) {
                self.responseModel = model
            }
        }
    }
}
