//
//  ListTableViewCell.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func didSelectAll(listId: Int)
    func didSelectBook(bookId: Int, in listId: Int)
}

final class ListTableViewCell: UITableViewCell{
    //MARK: - Properties
    weak var delegate: ListTableViewCellDelegate?
    private var list: List?
    
    private let collectionIdentifier = "BookCollectionCell"
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setList(_ list: List) {
        self.list = list
        titleLabel.text = list.title
        collectionView.reloadData()
    }
    
    private func setupViews() {
        mainView.pin(on: contentView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                superview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: .basePadding),
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: .basePadding),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -.basePadding)
            ]
        }
        
        titleLabel.pin(on: mainView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: .basePadding)
            ]
        }
        
        allButton.pin(on: mainView) { view, superview in
            [
                superview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: .basePadding),
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: .basePadding)
            ]
        }
        
        allButton.constraint(to: titleLabel) { view1, view2 in
            [
                view1.leftAnchor.constraint(equalTo: view2.rightAnchor, constant: .basePadding)
            ]
        }
        
        collectionView.pin(on: mainView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                superview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: .basePadding),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -.basePadding)
            ]
        }
        
        collectionView.layoutOn { view in
            [
                view.heightAnchor.constraint(equalToConstant: 200)
            ]
        }
        collectionView.constraint(to: allButton) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: .basePadding)
            ]
        }
    }
    
    //MARK: - Views
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var allButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("All", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(didSelectAll), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .basePadding
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: .basePadding, left: .basePadding, bottom: .basePadding, right: .basePadding)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Actions
    
    @objc
    private func didSelectAll() {
        guard let listId = list?.id else { return }
        delegate?.didSelectAll(listId: listId)
    }
}

/*
 Not so happy about this part of code, better to create separate class for interactions with collection
 */
extension ListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionIdentifier, for: indexPath) as? BookCollectionViewCell,
              let book = list?.books[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.setBook(book)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(list?.books.count ?? 0, 5)
    }
}

extension ListTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let list  else { return }
        let book = list.books[indexPath.item]
        delegate?.didSelectBook(bookId: book.id, in: list.id)
    }
}
