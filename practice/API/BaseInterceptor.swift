//
//  BaseInterceptor.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    // request 호출시 같이 호출됨
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("BaseInterceptor - adapt() called")
        
        var request = urlRequest
        
        // 헤더파일에 추가
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")

        // 공통 파라메터 추가
        var dictionary = [String:String]()
        
        dictionary.updateValue(API.API_KEY, forKey: "apikey")
        
        
        do {
            request =  try URLEncodedFormParameterEncoder().encode(dictionary, into: request)

        } catch {
            print(error)
        }
        
        completion(.success(request))
    }
    
    
    
    // 호출에 실패했을 때에 어떻게 처리할 것인지
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry() called")
        
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
    
        completion(.doNotRetry)
    }
}
