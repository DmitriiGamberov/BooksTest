//
//  ListsRouter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol ListsRouterInput: AlertShowable {
    func navigateToList(list: List)
    func navigateToBook(book: Book)
}

final class ListsRouter: ListsRouterInput {
    //MARK: - Properties
    weak var view: ModuleTransitionable?
    weak var modulesConfigurator: ModulesConfiguratorInput!
    
    func navigateToList(list: List) {
        let viewController = modulesConfigurator.booksModule(list: list, moduleOutput: nil)
        view?.getViewController().navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToBook(book: Book) {
        let viewController = modulesConfigurator.bookModule(book: book, moduleOutput: nil)
        view?.getViewController().navigationController?.pushViewController(viewController, animated: true)
    }
}
