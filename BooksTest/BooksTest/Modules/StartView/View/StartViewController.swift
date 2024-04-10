//
//  StartViewController.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol StartViewControllerOutput {
    func startViewControllerDidAppear()
}

final class StartViewController: UIViewController, ModuleTransitionable {
    
    // MARK: - Properties
    var output: StartViewControllerOutput?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textLabel.pin(on: view) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 20),
                superview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 20),
                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output?.startViewControllerDidAppear()
    }
    
    // MARK: - Views
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 33)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "BooksTest"
        return label
    }()
}
