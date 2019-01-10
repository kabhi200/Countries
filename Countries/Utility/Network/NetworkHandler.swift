//
//  NetworkHandler.swift
//  CountryInfo
//
//  Created by Abhishek on 07/01/19.
//  Copyright © 2019 Abhishek. All rights reserved.
//

import UIKit

class NetworkHandler: NSObject {

    static let sharedInstance = NetworkHandler()
    private override init() { }


    /// To send the request to fetch the country records based on user input
    ///
    /// - Parameters:
    ///   - searchString: the search input given by the user
    ///   - completion: if the search is successful and data is found, then return true alongwith the response, else false witthout any response
    func sendRequestToFetchCountryListFor(_ searchString : String , withCompletion completion: @escaping (Bool, Array<Any>) -> Void) {
        
        let urlString = countryListUrl + searchString
        
        guard let countrySearchUrl = URL(string: urlString) else {
            completion(false, [])
            return
        }
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: countrySearchUrl, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                        completion(true, json as! Array)
                    } else {
                        completion(false, [])
                    }
                } else {
                    completion(false, [])
                }
            }
//            guard let data = data else {
//                completion(false, [])
//                return
//            }
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
//                completion(false, [])
//                return
//            }
            
//            print(json)
//            completion(true, json as! Array)
        })
        task.resume()
    }
}
