//
//  Extension+UIViewController.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    func showAlert(with model: UIAlertModel?) -> Observable<Int> {
        guard let model = model else { return Observable.just(-1)}
        return Observable.create({ observer in
            let alertController = UIAlertController(title: model.title,
                                                    message: model.message,
                                                    preferredStyle: model.style)
            if let actions = model.actions {
                actions.enumerated().forEach({ index, action in
                    let action = UIAlertAction(title: action.title, style: action.style, handler: { _ in
                        observer.onNext(index)
                        observer.onCompleted()
                    })
                    alertController.addAction(action)
                })
            }
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        })
    }
}
