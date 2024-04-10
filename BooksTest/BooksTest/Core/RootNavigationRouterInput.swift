//
//  RootNavigationRouterInput.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import Foundation

protocol RootNavigationRouterInput: AnyObject {
    func navigateToLists(lists:[List])
}
