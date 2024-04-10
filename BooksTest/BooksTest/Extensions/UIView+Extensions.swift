//
//  UIView+Extensions.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 10.04.2024.
//

import UIKit

typealias EdgeClosure = (_ view: UIView, _ superview: UIView) -> [NSLayoutConstraint]
typealias LayoutOnEdgeClosure = (_ view: UIView) -> [NSLayoutConstraint]
typealias BetweenClosure = (_ view1: UIView, _ view2: UIView) -> [NSLayoutConstraint]

extension UIView {
    
    func pin(on superview: UIView, _ callback: EdgeClosure) {
        superview.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(callback(self, superview))
    }
    
    func layoutOn(_ callback: LayoutOnEdgeClosure) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(callback(self))
    }
    
    func constraint(to view: UIView, _ callback: BetweenClosure) {
        NSLayoutConstraint.activate(callback(self, view))
    }
}

protocol LayoutGuideProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: LayoutGuideProvider {
}

extension UILayoutGuide: LayoutGuideProvider {
}

extension UIView {
    var safeArea: LayoutGuideProvider {
        return safeAreaLayoutGuide
    }
}
