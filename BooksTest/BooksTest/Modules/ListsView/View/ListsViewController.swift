//
//  ListsViewController.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol ListsViewControllerInput: AnyObject {
    func setLists(_ lists: [List])
}

protocol ListsViewControllerOutput {
    func listsViewControllerDidLoad()
    func listsViewControllerDidSelect(list: Int)
    func listsViewControllerDidSelect(book: Int, in list: Int)
    func listsViewControllerRefresh()
}

/*
 Better to implement custom list based on UICollectionView, it will be more flexible
 */
final class ListsViewController: UITableViewController, ListsViewControllerInput, ModuleTransitionable {
    //MARK: - Properties
    
    var output: ListsViewControllerOutput?
    
    var data: [List] = []
    
    private let tableCellIdentifier = "ListCell"
    private let collectionCellIdentifier = "BookCollectionCell"
    
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
        tableView.allowsSelection = false
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: tableCellIdentifier)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        navigationItem.title = "Lists"
        output?.listsViewControllerDidLoad()
    }
    
    //MARK: - ListsViewControllerInput
    func setLists(_ lists: [List]) {
        data = lists
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.setList(data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Private
    @objc
    private func refresh() {
        output?.listsViewControllerRefresh()
    }
}

extension ListsViewController: ListTableViewCellDelegate {
    func didSelectAll(listId: Int) {
        output?.listsViewControllerDidSelect(list: listId)
    }
    
    func didSelectBook(bookId: Int, in listId: Int) {
        output?.listsViewControllerDidSelect(book: bookId, in: listId)
    }
}
