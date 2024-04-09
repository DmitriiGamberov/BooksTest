//
//  List.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation

final class List {
    let id: Int
    private(set) var title: String
    
    private(set) var books: [Book]
    
    init(from response: ListResponse) {
        self.id = response.id
        self.title = response.title
        self.books = []
    }
    
    func update(from response: ListResponse) {
        self.title = response.title
    }
    
    func setBooks(_ books: [Book]) {
        self.books = books
    }
}

struct ListResponse: Codable {
    let id: Int // Most probably here Int will be enough for this task, but theoreticaly number can be quite big, better to use String for ids
    let title: String
}
