//
//  WebServiceWrapper.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 24/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit
import Alamofire

public enum WebServiceResponse {
    case success(data:Data)
    case failedWithError(error:Error)
    case failedWithMessage(message:String)
}

class WebServiceWrapper: NSObject {
    class func callHTTPGetService(_ urlPath:String, param:[String: Any]?, competionHandler:((WebServiceResponse)->Void)?)  {
        guard let url = URL(string: urlPath) else
        {
            competionHandler?(.failedWithMessage(message: "Invalid URL"))
            return
        }
        let request = Alamofire.request(url, method: .get, parameters: param, encoding: JSONEncoding.prettyPrinted, headers: nil)
        let webserviceQueue = DispatchQueue(label: "com.rasmiranjan20.webserviceQueue")
        request.responseJSON(queue: webserviceQueue) { dataResponse in
            if let data = dataResponse.data {
                competionHandler?(.success(data: data))
            }
            else if let error = dataResponse.error {
                competionHandler?(.failedWithError(error: error))
            } else {
                competionHandler?(.failedWithMessage(message: "Unable to getch data, Unknown error."))
            }
        }
    }
}
