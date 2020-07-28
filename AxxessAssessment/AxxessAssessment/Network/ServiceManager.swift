//
//  ServiceManager.swift
//  AxxessAssessment
//
//  Created by Sandip Pund on 27/07/20.
//  Copyright © 2020 Sandip Pund. All rights reserved.
//

import Foundation
import Alamofire

class ServiceManager {
    // Singleton instance
    static let sharedInstance: ServiceManager = ServiceManager()
    private init() { }
    
    func getChallengeData(completionHandler: @escaping (_ response: [DataModel]?, _ error: Error?) -> Void) {
        Alamofire.request(Constants.url, method: .get)
            .responseData { response in
                switch response.result {
                    
                case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let dataModel = try decoder.decode([DataModel].self, from: data)
                            completionHandler(dataModel, nil)
                        } catch {
                            print(error.localizedDescription)
                        }
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
    
    // download image and cache it
//    func downloadImage(id: String, url: String, completionHandler: @escaping (_ image: UIImage?, _ error: Error?)-> Void) {
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("\(id).png")
//            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        Alamofire.download(url, to: destination).response { response in
//            if response.error == nil, let imagePath = response.destinationURL?.path,
//                let image = UIImage(contentsOfFile: imagePath) {
//                completionHandler(image, nil)
//            } else {
//                completionHandler(nil, response.error)
//            }
//        }
//    }
    
}
