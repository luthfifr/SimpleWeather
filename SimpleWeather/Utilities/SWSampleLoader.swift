//
//  SWSampleLoader.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 08/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import Foundation
struct SWSampleLoader {
    static func loadResponse(file: String) -> Data {
        return loadResponse(file: file, bundle: Bundle.main)
    }

    private static func loadResponse(file: String, bundle: Bundle) -> Data {
        guard let url = bundle.url(forResource: file, withExtension: "json"),
            let data = try? Data(contentsOf: url) else { return Data() }

        return data
    }
}
