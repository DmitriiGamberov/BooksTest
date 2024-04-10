//
//  BookRouter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol BookRouterInput: AlertShowable {
    
}

final class BookRouter: BookRouterInput {    
    //MARK: - Properties
    weak var view: ModuleTransitionable?
}
