//
//  MyLoger.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire

final class MyLoger : EventMonitor {
    
    let queue = DispatchQueue(label: "ApiLog")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger = requestDidResume()")
        debugPrint((request))
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger = request.didParseResponse()")
        
        
        debugPrint(request)
    }
}
