//
//  BookCollectionViewCell.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

final class BookCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBook(_ book: Book) {
        bookCoverView.loadImage(from: book.img)
        UIView.transition(with: titleLabel, duration: 0.5, options: .transitionCrossDissolve) { [weak self] in
            guard let self else { return }
            titleLabel.text = book.title
        }
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
        
        bookCoverView.layoutOn { view in
            [
                view.heightAnchor.constraint(equalToConstant: 100),
                view.widthAnchor.constraint(equalToConstant: 100)
            ]
        }
        
        bookCoverView.pin(on: mainView) { view, superview in
            [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: .basePadding),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding)
            ]
        }
        
        titleLabel.pin(on: mainView) { view, superview in
            [
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -.basePadding),
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: .basePadding),
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -.basePadding)
            ]
        }
        
        titleLabel.constraint(to: bookCoverView) { view1, view2 in
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
    
    private lazy var bookCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
}


