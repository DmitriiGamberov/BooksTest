//
//  AlertShowable.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import UIKit

protocol AlertShowable {
    var view: ModuleTransitionable? { get }
    func showAlertWithError(_ error: NSError, actionTitle: String?, actionHandler: (() -> Void)?)
}

extension AlertShowable {
    
    func showAlertWithError(_ error: NSError, actionTitle: String?, actionHandler: (() -> Void)?) {
        let title = "Error"
        let message = error.localizedDescription
        let alertAction = UIAlertAction(title: actionTitle ?? "Ok", style: .default) { action in
            actionHandler?()
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
    }
    
    func showAlertWithError(_ error: NSError, action: UIAlertAction?) {

    }
    
    private func presentAlert(_ alert: UIAlertController) {
        runOnMain {
            view?.getViewController().present(alert, animated: true)
        }
    }
}
