//
//  Extension+UILabel.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func assignData(with data: SWLabelDataParams) {
        self.text = data.text
        self.numberOfLines = data.numberOfLines
        self.textAlignment = data.textAlignment
        self.font = data.font ?? UIFont.systemFont(ofSize: 25)
    }
}
