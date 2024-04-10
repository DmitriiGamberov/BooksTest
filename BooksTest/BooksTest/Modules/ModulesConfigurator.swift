//
//  ModulesConfigurator.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol ModulesConfiguratorInput: AnyObject {
    func startModule(moduleOutput: StartViewModuleOutput?) -> StartViewController
    func listsModule(lists: [List], moduleOutput: ListsModuleOutput?) -> ListsViewController
    func booksModule(list: List, moduleOutput: BooksModuleOutput?) -> BooksViewController
    func bookModule(book: Book, moduleOutput: BookModuleOutput?) -> BookViewController
}

final class ModulesConfigurator: ModulesConfiguratorInput {
    weak var rootNavigationRouter:RootNavigationRouterInput?
    
    init(rootNavigationRouter: RootNavigationRouterInput?) {
        self.rootNavigationRouter = rootNavigationRouter
    }
    
    var networkManager: NetworkManager {
        return CoreObjectsStorage.shared.networkManager
    }
    
    func startModule(moduleOutput: (any StartViewModuleOutput)?) -> StartViewController {
        let view = StartViewController()
        let presenter = StartViewPresenter(networkManager: networkManager)
        let router = StartViewRouter()
        
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        
        router.view = view
        router.modulesConfigurator = self
        
        view.output = presenter
        
        return view
    }
    
    func listsModule(lists: [List], moduleOutput: ListsModuleOutput?) -> ListsViewController {
        let view = ListsViewController(style: .plain)
        let presenter = ListsPresenter(networkManager: networkManager, lists: lists)
        let router = ListsRouter()
        
        presenter.router = router
        presenter.view = view
        
        router.view = view
        router.modulesConfigurator = self
        
        view.output = presenter
        
        return view
    }
    
    func booksModule(list: List, moduleOutput: BooksModuleOutput?) -> BooksViewController {
        let view = BooksViewController(style: .plain)
        let presenter = BooksPresenter(networkManager: networkManager, list: list)
        let router = BooksRouter()
        
        presenter.router = router
        presenter.view = view
        
        router.view = view
        router.modulesConfigurator = self
        
        view.output = presenter
        
        return view
    }
    
    func bookModule(book: Book, moduleOutput: BookModuleOutput?) -> BookViewController {
        let view = BookViewController(book: book)
        let presenter = BookPresenter(networkManager: networkManager, book: book)
        let router = BookRouter()
        
        presenter.router = router
        presenter.view = view
        
        router.view = view
        
        view.output = presenter
        
        return view
    }
}
