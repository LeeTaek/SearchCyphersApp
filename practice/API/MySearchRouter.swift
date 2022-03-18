//
//  MySearchRouter.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire


enum MySearchRouter: URLRequestConvertible {
    
    case searchPlayerId(term: String )
    case searchMatches(term: String, gameType: String)
    case searchRank
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    // API 요청 방식에 따른 request 분기
    var method: HTTPMethod {
        return .get
    }
    
    // 엔드포인트 설정
    var endPoint: String {
        switch self {
        case .searchPlayerId:
            return "players"
            
        case let .searchMatches(term, _):
            return "players/\(term)/matches"
        
        case .searchRank :
            return "ranking/ratingpoint"
            
        }
        
    }
    
    
    // 파라미터 분기처리
    var parameters : [String : String] {
        
        switch self {
        case let .searchPlayerId(term):
            return ["nickname" : term]
            
        case let .searchMatches(_, gameType) :
            return ["gameTypeId" : gameType]
            
        case .searchRank :
            return ["limit":"30"]
        }
    }
    
    // throw가 있기 때문에 do catch 없이 try만 써도 된다.
    func asURLRequest() throws -> URLRequest {
        

            let url = baseURL.appendingPathComponent(endPoint)
            print("MySearchRouter - asURLRequest() searchPlayerId url : \(url)")
            
            var request = URLRequest(url: url)
            request.method = method
            
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            
            return request
  
    }
}
