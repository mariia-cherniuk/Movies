//
//   ImageCache.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

protocol ImageCacheProtocol {
    func add(image: UIImage, key: NSString)
    func image(forKey key: NSString) -> UIImage?
}

class ImageCache: ImageCacheProtocol {
    static let sharedInstance = ImageCache()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    //MARK: ImageCacheProtocol
    func add(image: UIImage, key: NSString) {
        imageCache.setObject(image, forKey: key)
    }
    
    func image(forKey key: NSString) -> UIImage? {
        return imageCache.object(forKey: key)
    }
}
