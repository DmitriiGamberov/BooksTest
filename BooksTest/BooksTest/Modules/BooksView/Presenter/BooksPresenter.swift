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
    private let networkManager: NetworkManager
    
    private var list: List
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager, list: List) {
        self.list = list
        self.networkManager = networkManager
        dataSource = ListsDataSource(networkManager: networkManager)
    }
    
    //MARK: - BooksViewControllerOutput
    func booksViewControllerDidLoad() {
        checkBooksForFullyLoad()
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
    
    private func checkBooksForFullyLoad() {
        for book in list.books {
            if book.author == nil {
                networkManager.getBook(id: book.id) {[weak self] bookResponse, error in
                    guard let self else { return }
                    if let bookResponse {
                        book.update(from: bookResponse)
                        view?.updateBook(book)
                    }
                    // I think it's not breaking UX if it's not loaded on this stage
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
