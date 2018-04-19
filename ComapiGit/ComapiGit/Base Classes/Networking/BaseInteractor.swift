//
//  BaseInteractor.swift
//  BooksyBIZ
//
//  Created by Dominik Kowalski on 05/12/2017.
//  Copyright © 2017 Sensi Soft. All rights reserved.
//

import UIKit

class BaseInteractor: NSObject {
    
    enum HTTPMethod : String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    var serverConfiguration: ServerConfiguration
    private(set) var sessionConfiguration: URLSessionConfiguration
    private(set) var session: URLSession
    
    private var request: URLRequest!
    
    init(timeout: Double) {
        let serverConfig = ServerConfiguration(address: "https://api.github.com")
        serverConfiguration = serverConfig
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = timeout
        sessionConfiguration.timeoutIntervalForResource = timeout
        session = URLSession(configuration: sessionConfiguration)
        
        super.init()
    }
    
    private func baseRequest() {
        request = URLRequest(url: serverConfiguration.address)
        addHeaders()
    }
    
    private func request(fromComponents components: URLComponents) {
        guard let url = components.url else { return }
        request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        addHeaders()
    }
    
    private func request(fromPath path: String, method: HTTPMethod) {
        var baseURL = serverConfiguration.address
        baseURL.appendPathComponent(path)
        request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        addHeaders()
    }
    
    private func addHeaders() {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    private func generate(url: String, parameters: [String : String]?) {
        if let params = parameters {
            guard let url = URL(string: [serverConfiguration.address.absoluteString, url].joined(separator: "/")) else { return }
            guard var componenets = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
            componenets.queryItems = []
            
            params.forEach {
                let item = URLQueryItem(name: $0, value: $1)
                componenets.queryItems?.append(item)
            }
            
            request(fromComponents: componenets)
        } else {
            request(fromPath: url, method: .GET)
        }
    }
    
    private func generate<T: Encodable>(url: String, method: HTTPMethod, body: T?) {
        switch method {
        default:
            request(fromPath: url, method: method)
            if let body = body {
                do {
                    let json = try JSONEncoder().encode(body)
                    request.httpBody = json
                } catch {
                    print("Error serializing JSON: \(error)")
                    return
                }
            }
        }
    }
    
    func parse<T: Decodable>(error: Error?, data: Data?, response: URLResponse?, success: (T, Paging?) -> (), failure: (Error?) -> ()) {
        if error == nil && data != nil {
            var paging: Paging?
            if let httpResponse = response as? HTTPURLResponse {
               paging = httpResponse.parsePaging()
            }
            
            do {
                let decoder = JSONDecoder.init()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try decoder.decode(T.self, from: data!)

                success(json, paging)
            } catch let parseError {
                failure(parseError)
            }
        } else if error != nil {
            failure(error)
        }
    }
    
    func request<Output: Decodable>(url: String, parameters: [String : String]?, completion: @escaping ((Output, Paging?) -> ()), failure: @escaping ((Error?) -> ())) {
        generate(url: url, parameters: parameters)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return }
            self.parse(error: error, data: data, response: response, success: { object, paging in
                DispatchQueue.main.async {
                    completion(object, paging)
                }
            }) { error in
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }.resume()
    }

    func request<Input: Encodable , Output: Decodable>(url: String, method: HTTPMethod, body: Input?, completion: @escaping ((Output, Paging?) -> ()), failure: @escaping ((Error?) -> ())) {
        if method == .GET {
            failure(nil)
            return
        }
        generate(url: url, method: method, body: body)
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return }
            self.parse(error: error, data: data, response: response, success: { object, paging in
                DispatchQueue.main.async {
                    completion(object, paging)
                }
            }) { error in
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }.resume()
    }
}


