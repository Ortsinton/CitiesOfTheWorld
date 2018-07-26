//
//  HTTPClient.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 25/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//

import UIKit

class HTTPClient: NSObject {
    private static let HOSTNAME = "http://connect-demo.mobile1.io/square1/connect/v1/city"
    private static let KEY_PAGE = "page"
    private static let KEY_INCLUDE = "include"
    private static let VALUE_COUNTRY = "country"
    private static let KEY_FILTER_CONTAINS = "filter[0][name][contains]"
    
    public static func fetchCitiesPageNumber(_ pageNumber: Int16, withCompletionHandler completionHandler: @escaping (([City]) -> (Void))) {
        var components = URLComponents(string: HOSTNAME)!
        components.queryItems = [URLQueryItem(name: KEY_PAGE, value: String(pageNumber)),
                                 URLQueryItem(name: KEY_INCLUDE, value: VALUE_COUNTRY)]
        fetchCitiesFromAPI(requestComponents: components, withCompletionHandler: completionHandler)
    }
    
    public static func filterCitiesByString(_ string: String, forPageNumber pageNumber: Int16, withCompletionHandler completionHandler: @escaping (([City]) -> (Void))) {
        var components = URLComponents(string: HOSTNAME)!
        components.queryItems = [URLQueryItem(name: KEY_FILTER_CONTAINS, value: string),
                                 URLQueryItem(name: KEY_PAGE, value: String(pageNumber)),
                                 URLQueryItem(name: KEY_INCLUDE, value: VALUE_COUNTRY)]
        fetchCitiesFromAPI(requestComponents: components, withCompletionHandler: completionHandler)
    }
    
    private static func fetchCitiesFromAPI(requestComponents: URLComponents, withCompletionHandler completionHandler: @escaping (([City]) -> (Void))) {
        var request = URLRequest(url: requestComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil,
                let data = data else {
                    print("There was an HTTP error: (\(error?.localizedDescription ?? "")")
                    completionHandler([])
                    return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            guard httpStatus?.statusCode == 200 else {
                print("There was an HTTP error: (code = \(String(httpStatus!.statusCode)).")
                completionHandler([])
                return
            }

            do {
                let jsonMessage = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let cities = CityParser.parseCitiesFromHttpResponse(jsonMessage)
                completionHandler(cities)
            }
            catch let error {
                print("HTTP response was successful but there was a problem when parsing it: \(error.localizedDescription).")
            }
        }
        task.resume()
    }
}
