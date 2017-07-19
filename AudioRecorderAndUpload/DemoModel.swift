//
//  DemoModel.swift
//  ShangWuMiao
//
//  Created by ju on 2017/7/19.
//  Copyright © 2017年 ju. All rights reserved.
//

import UIKit
import Alamofire


class DemoModel: NSObject {

    static func uploadRecord(data: Data, completionHandler: @escaping (_ status: Bool, _ info: String) -> ()) {
    
        // Transform mp3 data file to stream file
        func urlRequestWithComponents(url: URL,
                                      parameters: Dictionary<String, String>,
                                      audioData: Data) -> (data: Data, request: URLRequestConvertible) {
            
            // create url request to send
            var mutableURLRequest = URLRequest(url: url)
            mutableURLRequest.httpMethod = "POST"
            
            let boundaryConstant = "myRandomBoundary12345";
            let contentType = "multipart/form-data;boundary="+boundaryConstant
            mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            // create upload data to send
            let body = NSMutableData()
            
            // add audio
            body.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"music\"; filename=\"play.mp3\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(audioData as Data)
            
            // add parameters
            for (key, value) in parameters {
                body.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
            }
            body.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
            
            return (body as Data, mutableURLRequest as URLRequestConvertible)
        }
        
        // --------------------------------------------
        let inRealProject = false
        
        if inRealProject {
            
            let url = URL(string: "you url string path")!
            
            let parameters = ["your key": "your value"]
            
            
            let dataRequest = urlRequestWithComponents(url: url,
                                                       parameters: parameters,
                                                       audioData: data)
            
            
            Alamofire.upload(dataRequest.data,
                             with: dataRequest.request).responseJSON { (response) in
                                switch response.result {
                                case .success(let jsonResponse):
                                    print(jsonResponse)
                                case .failure(let error):
                                    completionHandler(false, "发生错误")
                                    print("error: \(error)")
                                }
            }
        }
        // --------------------------------------------

    }

}
