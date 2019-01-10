//
//  Extensions.swift
//  CountryInfo
//
//  Created by Abhishek on 08/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit
import SVGKit
//import SVGKit

//let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func downloadImageFrom(_ imageUrlString:String) {
        self.contentMode = .scaleAspectFit

        if !NetworkManager.isNetworkAvailable() {
            if let cachedImage = CountryListViewModel.sharedInstance.imageCache.object(forKey: imageUrlString as NSString) as? UIImage {
                self.image = cachedImage
                return
            }
        }
        
        let imageUrl = URL(string: imageUrlString)

        URLSession.shared.dataTask(with: imageUrl!) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let anSVGImage: SVGKImage = SVGKImage(data: data),
                let image = anSVGImage.uiImage
                else { return }
            DispatchQueue.main.async() {
//                imageCache.setObject(image, forKey: link as NSString)
                self.image = image

            }
            }.resume()

    }
}
