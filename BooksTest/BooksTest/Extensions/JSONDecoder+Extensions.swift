//
//  JSONDecoder+Extensions.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation

extension JSONDecoder {
    static func baseDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
}
