//
//  BookViewController.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

protocol BookViewControllerInput: AnyObject {
    func showIndicator()
    func setBook(_ book: Book)
}

protocol BookViewControllerOutput {
    func bookViewControllerDidLoad()
    func bookViewControllerRefresh()
}

final class BookViewController: UIViewController, BookViewControllerInput, ModuleTransitionable {
    //MARK: - Properties
    
    var output: BookViewControllerOutput?
    var data: Book
    
    //MARK: - Lifecycle
    init(book: Book) {
        data = book
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        output?.bookViewControllerDidLoad()
    }
    
    //MARK: - BookViewControllerInput
    func showIndicator() {
        indicatorView.startAnimating()
    }
    
    func setBook(_ book: Book) {
        data = book
        runOnMain { [weak self] in
            guard let self else { return }
            bookCoverView.loadImage(from: book.img)
            navigationItem.title = book.title
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
                guard let self else { return }
                titleLabel.text = book.title
                authorLabel.text = book.author
                isbnLabel.text = book.isbn
                publicationDateLabel.text = book.dateString()
                descriptionLabel.text = book.description
            }
            refreshControl.endRefreshing()
            indicatorView.stopAnimating()
        }
    }
    
    //MARK: - Private
    private func setupViews() {
        let viewWidth = view.frame.width
        scrollView.pin(on: view) { view, superview in
            [
                view.topAnchor.constraint(equalTo: superview.topAnchor),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                view.leftAnchor.constraint(equalTo: superview.leftAnchor),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor)
            ]
        }
        scrollContainerView.pin(on: scrollView) { view, superview in
            [
                view.topAnchor.constraint(equalTo: superview.topAnchor),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                view.leftAnchor.constraint(equalTo: superview.leftAnchor),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor),
                view.widthAnchor.constraint(equalTo: superview.widthAnchor)
            ]
        }
        
        bookCoverView.pin(on: scrollContainerView) { view, superview in
            [
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: .basePadding),
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        
        bookCoverView.layoutOn { view in
            [
                view.heightAnchor.constraint(equalToConstant: viewWidth - 2 * .basePadding),
                view.widthAnchor.constraint(equalToConstant: viewWidth - 2 * .basePadding)
            ]
        }
        
        titleLabel.pin(on: scrollContainerView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        titleLabel.constraint(to: bookCoverView) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 2 * .basePadding)
            ]
        }
        
        authorLabel.pin(on: scrollContainerView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        authorLabel.constraint(to: titleLabel) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: .basePadding)
            ]
        }
        
        isbnLabel.pin(on: scrollContainerView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        isbnLabel.constraint(to: authorLabel) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: .basePadding)
            ]
        }
        
        publicationDateLabel.pin(on: scrollContainerView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        publicationDateLabel.constraint(to: isbnLabel) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: .basePadding)
            ]
        }
        
        descriptionLabel.pin(on: scrollContainerView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -.basePadding)
            ]
        }
        descriptionLabel.constraint(to: publicationDateLabel) { view1, view2 in
            [
                view1.topAnchor.constraint(equalTo: view2.bottomAnchor, constant: 2 * .basePadding)
            ]
        }
        
        view.addSubview(indicatorView)
        view.bringSubviewToFront(indicatorView)
    }
    
    @objc
    private func refresh() {
        output?.bookViewControllerRefresh()
    }
    
    //MARK: - Views
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.refreshControl = refreshControl
        return scroll
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var scrollContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var bookCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var isbnLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var publicationDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        return indicator
    }()
}
