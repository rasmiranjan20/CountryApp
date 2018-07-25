//
//  CountryInfoWebAPI.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 24/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit
import Alamofire

private enum CountryInfoAPI :String {
    case countryInfo = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

typealias CountryInformation = (title:String?, info:[CountryInfoModel]?)

enum CountryInfoResponse {
    case countryData(CountryInformation)
    case failedWithError( error:Error)
    case failedWithMessage(message:String)
}

///Country API Call
class CountryInfoWebAPI: NSObject {
    class func getCountryInfo(completionHandler:@escaping(CountryInfoResponse)->Void) {
        WebServiceWrapper.callHTTPGetService(CountryInfoAPI.countryInfo.rawValue, param: nil) { response in
            switch response {
                case .success(data: let data):
                    completionHandler(.countryData(parseCountryData(data:data)))
                case .failedWithError(error: let error):
                    completionHandler(.failedWithError(error: error))
                case .failedWithMessage(message: let message):
                    completionHandler(.failedWithMessage(message: message))
            }
        }
    }
    
    /// Parse Country data
    ///
    /// - Parameter data: Raw data which received from cloud
    /// - Returns: return CountryInformation
    class func parseCountryData(data:Data) -> CountryInformation {
        if let validJsonString = String(data: data, encoding: .isoLatin1), let convertData = (validJsonString.data(using: .utf8)) {
            do {
                let dictionary  = try JSONSerialization.jsonObject(with: convertData, options: .mutableContainers)
                var title           = ""
                var countryArray    = [CountryInfoModel]()
                if let dictionary = dictionary as? [String : Any] {
                    title = dictionary["title"] as? String ?? ""
                    
                    if let infoArray = dictionary["rows"] as? [[String : Any]] {
                        for infoDictionary in infoArray {
                            let country = CountryInfoModel()
                            country.title               = infoDictionary["title"] as? String ?? ""
                            country.countryDescription  = infoDictionary["description"] as? String ?? ""
                            country.imageHref           = infoDictionary["imageHref"] as? String ?? ""
                            countryArray.append(country)
                        }
                    }
                    
                }
                return (title:title, info:countryArray)
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        return (title:nil, info:nil)
    }
}
