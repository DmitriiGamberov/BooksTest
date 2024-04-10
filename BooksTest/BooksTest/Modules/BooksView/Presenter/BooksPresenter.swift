//
//  BooksPresenter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol BooksModuleOutput: AnyObject {
}

final class BooksPresenter: BooksViewControllerOutput {
    //MARK: - Properties
    
    var router: BooksRouterInput?
    var moduleOutput: BooksModuleOutput?
    weak var view: BooksViewControllerInput?
    
    private let dataSource: ListsDataSource
    
    private var list: List
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager, list: List) {
        self.list = list
        dataSource = ListsDataSource(networkManager: networkManager)
    }
    
    //MARK: - BooksViewControllerOutput
    func booksViewControllerDidLoad() {
        view?.setList(list)
    }
    
    func booksViewControllerDidSelect(book: Int) {
        guard let book = list.books.first(where: {$0.id == book}) else { return }
        router?.navigateToBook(book: book)
    }
    
    func booksViewControllerRefresh() {
        reloadList()
    }
    
    //MARK: - Private
    private func reloadList() {
        dataSource.refresh {[weak self] lists, errors in
            guard let self else { return }
            if let error = errors.first {
                handleError(error)
            } else {
                guard let list = lists.first(where: {$0.id == self.list.id}) else {
                    let error = NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Seems like this list was deleted"])
                    handleError(error)
                    return
                }
                runOnMain { [weak self] in
                    guard let self else { return }
                    view?.setList(list)
                }
            }
        }
    }
    
    private func handleError(_ error: NSError) {
        router?.showAlertWithError(error, actionTitle: "Try again", actionHandler: { [weak self] in
            guard let self else { return }
            self.reloadList()
        })
    }
}
