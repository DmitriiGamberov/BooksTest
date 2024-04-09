//
//  ImageDowloader.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import UIKit

final class ImageCache {
    /*
     Here better to add cache lifetime or just use 3rd paty library such as SDWebImage/Kingfisher
     */
    private var cache: [URL: UIImage] = [:]
    
    func cacheImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }
    
    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
}

final class ImageDowloader {
    private let cache = ImageCache()
    
    func imageFromUrl(_ url: URL) async throws -> UIImage {
        if let cachedImage = cache.image(for: url) {
            return cachedImage
        }
        
        let data = try await downloadImageData(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something is wrong with the image"])
        }

        cache.cacheImage(image, for: url)
        return image
    }
    
    private func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
