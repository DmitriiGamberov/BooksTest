//
//  StartViewRouter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol StartViewRouterInput: AlertShowable {
    
}

final class StartViewRouter: StartViewRouterInput {
    // MARK: - Properties
    weak var view: ModuleTransitionable?
    weak var modulesConfigurator: ModulesConfiguratorInput!
}
