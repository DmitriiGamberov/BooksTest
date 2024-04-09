//
//  AlertShowable.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import UIKit

protocol AlertShowable {
    var view: ModuleTransitionable? { get }
    func showAlertWithError(_ error: NSError)
}

extension AlertShowable {
    
    func showAlertWithError(_ error: NSError) {
        let title = "Error"
        let message = error.localizedDescription
        let actionTitle = "Ok"
        
        let alertAction = UIAlertAction(title: actionTitle, style: .destructive)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertAction)
    }
    
    private func presentAlert(_ alert: UIAlertController) {
        runOnMain {
            view?.getViewController().present(alert, animated: true)
        }
    }
}
