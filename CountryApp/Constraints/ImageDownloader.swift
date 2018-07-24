//
//  ImageDownloader.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 25/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit
import Alamofire

class ImageDownloader: NSObject {
    
    class func downloadImage(path:String, completionHandler:((WebServiceResponse)->Void)?) {
        WebServiceWrapper.downloadImage(path, completionHandler: completionHandler)
    }
    
    @discardableResult class func storeInCache(path:String, data:Data) -> Bool {
        let cachePath = NSString(string:NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)
        let filePath = cachePath.appendingPathComponent(NSString(string: path).lastPathComponent)
       return FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    @discardableResult class func fetchFromCache(path:String) -> Data?  {
        let cachePath = NSString(string:NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)
        let filePath = cachePath.appendingPathComponent(NSString(string: path).lastPathComponent)
        if FileManager.default.fileExists(atPath: filePath) {
           return try? Data(contentsOf: URL(fileURLWithPath: filePath))
        }
        return nil
    }
}
