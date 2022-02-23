//
//  MySearchRouter.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire


enum MySearchRouter: URLRequestConvertible {
    
    case searchPlayers(term: String)
    case searchPlayerId(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL )!
    }
    
    // API 요청 방식에 따른 request 분기
    var method: HTTPMethod {
        switch self {
        case .searchPlayers, .searchPlayerId:
            return .get
//        case .post:
//            return .post
        }
    }
    
    // 엔드포인트 설정
    var endPoint: String {
        switch self {
        case .searchPlayers:
            return "players"
        case .searchPlayerId:
            return "players/playerId"
        }
    }
    
    
    // 파라미터 분기처리
    var parameters : [String : String] {
        
        switch self {
        case let .searchPlayers(term):
            return ["nickname" : term]
      
        case let .searchPlayerId(term):
            return ["playerId" : term]
        }
    }
    
    // throw가 있기 때문에 do catch 없이 try만 써도 된다.
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("MySearchRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
