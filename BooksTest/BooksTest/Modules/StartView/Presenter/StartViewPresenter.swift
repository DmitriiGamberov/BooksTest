//
//  StartViewPresenter.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol StartViewModuleOutput: AnyObject {
    func startModuleDidFinishLoad(lists: [List])
}

final class StartViewPresenter: StartViewControllerOutput {
    
    //MARK: - Properties
    
    var router: StartViewRouterInput?
    var moduleOutput: StartViewModuleOutput?
    private let networkManager: NetworkManager
    
    private let listsDataSource: ListsDataSource
    
    //MARK: - Lifecycle
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        listsDataSource = ListsDataSource(networkManager: networkManager)
    }
    
    //MARK: - StartViewControllerOutput
    func startViewControllerDidAppear() {
        loadLists()
    }
    
    //MARK: - Private
    private func loadLists() {
        listsDataSource.refresh {[weak self] lists, errors in
            guard let self else { return }
            if let error = errors.first {
                handleError(error)
            } else {
                moduleOutput?.startModuleDidFinishLoad(lists: lists)
            }
        }
    }

    private func handleError(_ error: NSError) {
        router?.showAlertWithError(error, actionTitle: "Try again", actionHandler: { [weak self] in
            guard let self else { return }
            self.loadLists()
        })
    }
    
}
