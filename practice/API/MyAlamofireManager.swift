//
//  MyAlamofireManager.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation
import Alamofire
import SwiftyJSON

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
    

    func getUserInfo(searchTerm userInput: String, completion: @escaping (Result<[userInfo], MyError>) -> Void) {
        
        print("MyAlMyAlamofireManager - getUserInfo() called userInput : \(userInput)")
        
        self.session
            .request(MySearchRouter.searchPlayers(term: userInput))
            .validate(statusCode: 200...400)         // 200-400까지만 허용하고 401부터는 에러가 뜸. 에러일 경우 baseRetry가 뜸
            .responseJSON(completionHandler:{
                response in
                
                guard let responseValue = response.value else {return}
                
                    var player = [userInfo]()
                    let responseJson = JSON(responseValue)
                    let jsonArray = responseJson["rows"]
                    
                    print("JsonArray count : \(jsonArray.count)")
                    
                    
                    for (index, subJson): (String, JSON) in jsonArray {
                        
                        print("index : \(index), subJson : \(subJson)")
                        
                        // 데이터 파싱
                        guard let playerId = subJson["playerId"].string,
                              let nickname = subJson["nickname"].string else {return}
                        
                        let grade = subJson["grade"].intValue
                        
                        let userInfoItem = userInfo(playerId: playerId, nickname: nickname, grade: grade)
                        
                        // 배열에 넣고
                        player.append(userInfoItem)
                        
                        if player.count > 0 {
                            completion(.success(player))
                            print(player)
                        } else {
                            completion(.failure(.noContent))
                        }
                        
                }
                
                print(player)
        })
     
        
    }
    
    
}
