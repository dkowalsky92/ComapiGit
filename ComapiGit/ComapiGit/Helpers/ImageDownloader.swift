//
//  Created by Dominik Kowalski on 18.04.2017.
//  Copyright © 2017 Sensi Soft. All rights reserved.
//
//

import UIKit

class ImageDownloader {

    fileprivate let operationQueue = OperationQueue()
    fileprivate let imageSession: URLSession
    
    deinit {
        imageSession.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }

    init() {
        operationQueue.maxConcurrentOperationCount = 3

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy

        imageSession = URLSession(configuration: configuration, delegate: nil, delegateQueue: operationQueue)
    }

    func download(_ url: URL, success: ((UIImage?) -> ())?, failure: ((Error?) -> ())?) {
        imageSession.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    success?(image)
                }

                return
            }

            DispatchQueue.main.async {
                failure?(error)
            }
        }.resume()
    }

    func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
}
