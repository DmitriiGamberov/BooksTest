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


/*
 Also some notes about API,
 In my opinion it's not optimized for usage like this test assigment.
 For best optimizations it's better to add request for list with books included,
 it will help on book list screen to update it.
 Also another point is that for "short" version of books the data is not enough on list screen,
 it can be solved by adding requests by ids for each book for the list, but potentialy it will take too long.
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
