//
//  ListsDataSource.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

final class ListsDataSource: NSObject {
    //MARK: - Properties
    private let networkManager: NetworkManager
    
    private var errors: [NSError] = []
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    //MARK: - Actions
    
    func refresh(completion: @escaping ([List], [NSError]) -> Void) {
        errors.removeAll()
        var resultListsResponse: [ListResponse]?
        var resultBooksResponse: [BookResponse]?
        let group = DispatchGroup()
        group.enter()
        networkManager.getLists {[weak self] listsResponse, error in
            guard let self else {
                group.leave()
                return
            }
            if let error {
                self.errors.append(error)
            } else {
                resultListsResponse = listsResponse
            }
            group.leave()
        }
        group.enter()
        networkManager.getBooks {[weak self] booksResponse, error in
            guard let self else {
                group.leave()
                return
            }
            if let error {
                self.errors.append(error)
            } else {
                resultBooksResponse = booksResponse
            }
            group.leave()
        }
        group.wait()
        group.notify(queue: .global(qos: .background)) { [weak self] in
            guard let self else { return }
            if !errors.isEmpty {
                completion([], errors)
            } else {
                if let resultListsResponse, let resultBooksResponse {
                    let lists = resultListsResponse.map({List(from: $0)})
                    let books = resultBooksResponse.map({Book(from: $0)})
                    lists.forEach { list in
                        list.setBooks(books.filter({$0.listId == list.id}))
                    }
                    completion(lists, [])
                } else {
                    completion([], [])
                }
            }
        }
    }
}
