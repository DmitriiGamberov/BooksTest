//
//  BookPresenter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol BookModuleOutput: AnyObject {
    func bookLoaded(book: Book)
}

final class BookPresenter: BookViewControllerOutput {
    //MARK: - Properties
    
    var router: BookRouterInput?
    var moduleOutpur: BookModuleOutput?
    weak var view: BookViewControllerInput?
    
    private let networkManager: NetworkManager
    private var book: Book
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager, book: Book) {
        self.book = book
        self.networkManager = networkManager
    }
    
    //MARK: - BookViewControllerOutput
    func bookViewControllerDidLoad() {
        if book.author != nil {
            view?.setBook(book)
        } else {
            view?.showIndicator()
            reloadBook()
        }
    }
    
    func bookViewControllerRefresh() {
        reloadBook()
    }
    
    //MARK: - Private
    private func reloadBook() {
        networkManager.getBook(id: book.id) {[weak self] bookResponse, error in
            guard let self else { return }
            if let error {
                handleError(error)
            } else if let bookResponse {
                book.update(from: bookResponse)
                view?.setBook(book)
            } else {
                let error = NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Seems like this book was deleted"])
                handleError(error)
                return
            }
            
        }
    }
    
    private func handleError(_ error: NSError) {
        router?.showAlertWithError(error, actionTitle: "Try again", actionHandler: { [weak self] in
            guard let self else { return }
            self.reloadBook()
        })
    }
}
