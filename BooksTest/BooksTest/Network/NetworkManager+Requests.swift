//
//  NetworkManager+Requests.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation

/*
 This part can be splitted to multiple files, but here we have only 3 requests so let's keep it in one place
 */

private let listsPath = "lists"
private let booksPath = "books"
private let bookPath = "book"

extension NetworkManager {
    func getLists(completion: @escaping([ListResponse]?, NSError?) -> Void) {
        let pathURL = baseURL.appendingPathComponent(listsPath)
        let _ = requestWith(pathURL, method: .GET, completion: completion)
    }
    
    func getBooks(completion: @escaping([BookResponse]?, NSError?) -> Void) {
        let pathURL = baseURL.appendingPathComponent(booksPath)
        let _ = requestWith(pathURL, method: .GET, completion: completion)
    }
    
    func getBook(id: Int, completion: @escaping(BookResponse?, NSError?) -> Void) {
        let pathURL = baseURL.appendingPathComponent(bookPath).appendingPathComponent("\(id)")
        let _ = requestWith(pathURL, method: .GET, completion: completion)
    }
}
