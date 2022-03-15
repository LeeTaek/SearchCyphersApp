//
//  MyAlamofireManager.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    
    // 싱글턴 적용
    static let shared = MyAlamofireManager()

    // 인터셉터 : 공통 파라미터, 인증, 헤더에 무언가 추가 등
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ]
    )
    
    
    // 로거 이벤트 모니터 설정
    let monitors = [MyLoger(), MyApiStatusLogger()] as [EventMonitor]
    
    
    // 세션 설정
    var session : Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    
    
    

    func getUserInfo(searchTerm userInput: String, completion: @escaping (Result<PlayerInfo, MyError>) -> Void) {
        
        print("MyAlMyAlamofireManager - getUserInfo() called userInput : \(userInput)")
        
        self.session
            .request(MySearchRouter.searchPlayerId(term: userInput))
            .validate(statusCode: 200...400)         // 200-400까지만 허용하고 401부터는 에러가 뜸. 에러일 경우 baseRetry가 뜸
            .responseJSON(completionHandler:{ response in
                
                switch response.result {
                    
                case .success(let res) :
                    do {
                        
                        let JsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                        
                        let user = try JSONDecoder().decode(UserInfo.self, from: JsonData)
                        
                        if !user.rows.isEmpty {
                            completion(.success(user.rows.first!))
                        } else {
                            completion(.failure(.noPlayer))
                        }
                        
                    } catch {
                        print(error)
                        completion(.failure(.noContent))
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            })
        }
    
    
    
    func getMatchInfo(searchterm userInput: String, gameTypeID : String ,completion: @escaping (Result<MatchInfo, MyError>) -> Void) {
        print("MyAlamofireManager - getMatchInfo() called ")
        
        self.session
            .request(MySearchRouter.searchMatches(term: userInput, gameType: gameTypeID))
            .validate().validate(statusCode: 200...400)
            .responseJSON(completionHandler: {response in
                
                switch response.result {
                case .success(let res) :
                    do {
                        let JsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                        
                        let matchingData = try JSONDecoder().decode(MatchInfo.self, from: JsonData)
                        
                        completion(.success(matchingData))
                        
                        
                    } catch {
                        print(error)
                        completion(.failure(.noMatcingRecord))
                    }
                    
                case .failure(let err) :
                    print(err.localizedDescription)
                }
            })
    }
    
    
}
