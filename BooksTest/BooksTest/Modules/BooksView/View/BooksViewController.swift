//
//  BooksViewController.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol BooksViewControllerInput: AnyObject {
    func setList(_ list: List)
}

protocol BooksViewControllerOutput {
    func booksViewControllerDidLoad()
    func booksViewControllerDidSelect(book: Int)
    func booksViewControllerRefresh()
}

final class BooksViewController: UITableViewController, BooksViewControllerInput, ModuleTransitionable {
    //MARK: - Properties
    
    var output: BooksViewControllerOutput?
    
    var data: [Book] = []
    
    private let tableCellIdentifier = "BooksCell"
    
    //MARK: - Lifecycle
    override init(style: UITableView.Style) {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        output?.booksViewControllerDidLoad()
    }
    
    //MARK: - BooksViewControllerInput
    func setList(_ list: List) {
        data = list.books
        navigationItem.title = list.title
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        cell.setBook(data[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.booksViewControllerDidSelect(book: data[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Private
    @objc
    private func refresh() {
        output?.booksViewControllerRefresh()
    }
}
