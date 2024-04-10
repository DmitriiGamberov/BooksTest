//
//  UIImageView+Extensions.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 11.04.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        Task {
            do {
                let image = try await CoreObjectsStorage.shared.imageDowloader.imageFromUrl(url)
                runOnMain { [weak self] in
                    guard let self else { return }
                    UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve) {
                        self.image = image
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
