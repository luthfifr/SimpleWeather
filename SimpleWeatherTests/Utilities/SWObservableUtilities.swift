//
//  SWObservableUtilities.swift
//  SimpleWeatherTests
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import RxSwift
import RxTest

struct HCObservableUtilities {
    static func latestValueFrom<T>(observable: Observable<T>,
                                   disposeBag: DisposeBag) -> T? {
        return latestValueFrom(observable: observable,
                               disposeBag: disposeBag,
                               executeBlock: nil)
    }

    static func latestValueFrom<T>(observable: Observable<T>,
                                   disposeBag: DisposeBag,
                                   executeBlock: (() -> Void)?) -> T? {
        let events = self.events(from: observable,
                                 disposeBag: disposeBag,
                                 executeBlock: executeBlock)

        return events.last?.value.element
    }

    static func events<T>(from observable: Observable<T>,
                          disposeBag: DisposeBag) -> [Recorded<Event<T>>] {
        return events(from: observable,
                      disposeBag: disposeBag,
                      executeBlock: nil)
    }

    static func events<T>(from observable: Observable<T>,
                          disposeBag: DisposeBag,
                          executeBlock: (() -> Void)?) -> [Recorded<Event<T>>] {
        let testScheduler = TestScheduler(initialClock: 0)
        let testObserver = testScheduler.createObserver(T.self)

        observable
            .bind(to: testObserver)
            .disposed(by: disposeBag)

        if let executeBlock = executeBlock { executeBlock() }

        return testObserver.events
    }
}
