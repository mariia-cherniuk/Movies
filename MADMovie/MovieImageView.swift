//
//  UIImageView.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

class MovieImageView : UIImageView {
    
    func downloadImageFrom(path: String) {
        self.image = nil
        
        if let obj = ImageCache.sharedInstance.image(forKey: path as NSString) {
            self.image = obj
            return
        }
        
        let posterRequest = PosterRequest().request(posterPath: path)
        let dataTask = URLSession.shared.dataTask(with: posterRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let imageToCache = UIImage(data: data) {
                    ImageCache.sharedInstance.add(image: imageToCache, key: path as NSString)
                    self.image = imageToCache
                }
            }
        }
        
        dataTask.resume()
    }
}
