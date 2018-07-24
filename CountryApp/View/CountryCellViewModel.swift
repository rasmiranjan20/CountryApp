//
//  CountryCellViewModel.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit

class CountryCellViewModel: NSObject {
    
    var country         : CountryInfoModel!
    func reload(data:CountryInfoModel) {
        country         = data
    }
    func title() -> String {
        return country.title
    }
    func information() -> String {
        return country.countryDescription
    }
    func showThumbnail(completionHandler:@escaping(UIImage?)->Void) -> UIImage? {
        if let data = ImageDownloader.fetchFromCache(path: country.imageHref) {
            return UIImage(data: data)
        }
        else if country.imageHref.count > 0 {
            ImageDownloader.downloadImage(path: country.imageHref) {[unowned self] response in
                switch response {
                    case .success(data: let data):
                        ImageDownloader.storeInCache(path: self.country.imageHref, data: data)
                        completionHandler(UIImage(data: data))
                    default:
                        completionHandler(nil)
                }
            }
        }
        return UIImage(named: "no_icon")
    }
}
