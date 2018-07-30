//
//  WebServiceWrapper.swift
//  CountryApp
//
//  Created by Rasmiranjan Sahu on 24/07/18.
//  Copyright © 2018 Rasmiranjan Sahu. All rights reserved.
//

import UIKit
import Alamofire
import Reachability
public enum WebServiceResponse {
    case success(data:Data)
    case failedWithError(error:Error)
    case failedWithMessage(message:String)
}


/// This Class is used as Wrapping web service. No need to import 3rd party library in every class
class WebServiceWrapper: NSObject {
    
static let shared = WebServiceWrapper()

/// Check network reachability.
public var isReachable = false
lazy var reachability = Reachability()
 
    func checkReachability() {
        reachability?.whenReachable = {[weak self] status in
            switch status.connection {
            case .none:
                self?.isReachable = false
            default:
                self?.isReachable = true
            }
        }
        do {
            try reachability? .startNotifier()
        } catch {
            print("error ::\(error)")
        }
        isReachable = !(reachability?.connection == .none)
    }
    
    func stopNetworkChecking() {
        reachability? .stopNotifier()
    }
    
    /// Default get method for web service call
    ///
    /// - Parameters:
    ///   - urlPath: url path
    ///   - param: Webservice parameter
    ///   - completionHandler: Callback clousere for passing messag.
    class func callHTTPGetService(_ urlPath:String, param:[String: Any]?, completionHandler:((WebServiceResponse)->Void)?)  {
        guard let url = URL(string: urlPath) else
        {
            completionHandler?(.failedWithMessage(message: "Invalid URL"))
            return
        }
        let request = Alamofire.request(url, method: .get, parameters: param, encoding: JSONEncoding.prettyPrinted, headers: nil)
        let webserviceQueue = DispatchQueue(label: "com.rasmiranjan20.webserviceQueue")
        request.responseJSON(queue: webserviceQueue) { dataResponse in
            if let data = dataResponse.data {
                completionHandler?(.success(data: data))
            }
            else if let error = dataResponse.error {
                completionHandler?(.failedWithError(error: error))
            } else {
                completionHandler?(.failedWithMessage(message: "Unable to getch data, Unknown error."))
            }
        }
    }
    
    /// Download Image Class
    ///
    /// - Parameters:
    ///   - urlPath: Image web service path
    ///   - completionHandler: Callback clousere for passing messag.
    class func downloadImage(_ urlPath:String, completionHandler:((WebServiceResponse)->Void)?)  {
        guard let url = URL(string: urlPath) else
        {
            completionHandler?(.failedWithMessage(message: "Invalid URL"))
            return
        }
        print("image download ::\(urlPath)")
        let request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted, headers: nil)
        Alamofire.URLSessionConfiguration.default.timeoutIntervalForRequest = 60
        let imagedownloadqueue = DispatchQueue(label: "com.rasmiranjan20.imagedownloadqueue")
        request.responseData(queue: imagedownloadqueue) { dataResponse in
            if let data = dataResponse.data,
                let response = dataResponse.response , response.statusCode == 200 {
                completionHandler?(.success(data: data))
            } else if let error = dataResponse.error {
                completionHandler?(.failedWithError(error: error))
            } else {
                completionHandler?(.failedWithMessage(message: "Unable to getch data, Unknown error."))
            }
        }
    }
}
