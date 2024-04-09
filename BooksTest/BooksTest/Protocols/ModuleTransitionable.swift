//
//  ModuleTransitionable.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import UIKit

protocol ModuleTransitionable: UIViewController {
    func getViewController() -> UIViewController
}

extension ModuleTransitionable {
    func getViewController() -> UIViewController {
        return self
    }
}
