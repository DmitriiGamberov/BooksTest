//
//  Book.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation

final class Book {
    let id: Int
    private(set) var listId: Int
    private(set) var title: String
    private(set) var img: URL
    private(set) var isbn: String?
    private(set) var publicationDate: Date?
    private(set) var author: String?
    private(set) var description: String?
    
    init(from response: BookResponse) {
        self.id = response.id
        self.listId = response.list_id
        self.title = response.title
        self.img = response.img
        self.isbn = response.isbn
        self.publicationDate = response.publication_date
        self.author = response.author
        self.description = response.description
    }
    
    func update(from response: BookResponse) {
        self.listId = response.list_id
        self.title = response.title
        self.img = response.img
        self.isbn = response.isbn
        self.publicationDate = response.publication_date
        self.author = response.author
        self.description = response.description
    }
    
    func dateString() -> String {
        guard let publicationDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: publicationDate)
    }
}

struct BookResponse: Codable {
    let id: Int // The same as for List
    let list_id: Int // The same as for List
    let title: String
    let img: URL
    let isbn: String?
    let publication_date: Date?
    let author: String?
    let description: String?
}
