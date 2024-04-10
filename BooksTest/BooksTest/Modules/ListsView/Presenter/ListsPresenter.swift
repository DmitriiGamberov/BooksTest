//
//  ListsPresenter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol ListsModuleOutput: AnyObject {
}

final class ListsPresenter: ListsViewControllerOutput {
    
    //MARK: - Properties
    
    var router: ListsRouterInput?
    var moduleOutput: ListsModuleOutput?
    weak var view: ListsViewControllerInput?
    
    private let dataSource: ListsDataSource
    
    private var lists:[List]
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager, lists: [List]) {
        self.lists = lists
        dataSource = ListsDataSource(networkManager: networkManager)
    }
    
    //MARK: - ListsViewControllerOutput
    func listsViewControllerDidLoad() {
        view?.setLists(lists)
    }
    
    func listsViewControllerDidSelect(list: Int) {
        guard let list = lists.first(where: {$0.id == list}) else { return }
        router?.navigateToList(list: list)
    }
    
    func listsViewControllerDidSelect(book: Int, in list: Int) {
        guard let list = lists.first(where: {$0.id == list}), let book = list.books.first(where: {$0.id == book}) else { return }
        router?.navigateToBook(book: book)
    }
    
    func listsViewControllerRefresh() {
        reloadLists()
    }
    
    //MARK: - Private
    
    private func reloadLists() {
        dataSource.refresh {[weak self] lists, errors in
            guard let self else { return }
            if let error = errors.first {
                handleError(error)
            } else {
                self.lists = lists
                runOnMain { [weak self] in
                    guard let self else { return }
                    view?.setLists(lists)
                }
            }
        }
    }
    
    private func handleError(_ error: NSError) {
        router?.showAlertWithError(error, actionTitle: "Try again", actionHandler: { [weak self] in
            guard let self else { return }
            self.reloadLists()
        })
    }
}
