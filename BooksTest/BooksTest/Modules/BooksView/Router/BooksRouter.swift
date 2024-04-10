//
//  BooksRouter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol BooksRouterInput: AlertShowable {
    func navigateToBook(book: Book)
}

final class BooksRouter: BooksRouterInput {
    weak var view: ModuleTransitionable?
    weak var modulesConfigurator: ModulesConfiguratorInput!
    
    func navigateToBook(book: Book) {
        let viewController = modulesConfigurator.bookModule(book: book, moduleOutput: nil)
        view?.getViewController().navigationController?.pushViewController(viewController, animated: true)
    }
}
