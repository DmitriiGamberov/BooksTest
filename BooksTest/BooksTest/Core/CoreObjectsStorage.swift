//
//  CoreObjectsStorage.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

final class CoreObjectsStorage {
    static let shared = CoreObjectsStorage()
    
    let networkManager = NetworkManager()
    let imageDowloader = ImageDowloader()
}
