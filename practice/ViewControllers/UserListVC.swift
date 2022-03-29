//
//  UserList.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit

class UserListVC : BaseVC {
  
    
    var rankData = [RankRow]()
    var matchInfo : MatchInfo?
    let rank = RankingData()
    let segmentIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userListVc - viewDidLoad() called")

        
        getRank()
        rank.getFirebaseDatabase()

        
    }
    

    
    // 랭커 리스트 받아옴
    func getRank() {
        MyAlamofireManager.shared
            .getRankData(completion: {result in
                switch result {
                case .success(let ran) :
                    print("RankingData - getRank.success rank.Count: \(ran.count)")

                    self.rankData = ran

                    for i in 0..<self.rankData.count {
                        
                        if i%5 == 0 {
                            Thread.sleep(forTimeInterval: 2)
                        }
                        
                        self.getMatchingInfo(playerId: self.rankData[i].playerID)
                    }
                case .failure(let error) :
                    print("RankingData - failure, error : \(error.rawValue)")
                }
            })
    }
    
    
    // 매칭 기록 request
    func getMatchingInfo(playerId : String) {
        MyAlamofireManager.shared
            .getMatchInfo(searchterm: playerId, segmentIndex: segmentIndex ,gameTypeID: "rating") { result in
                switch result {
                case .success(let match) :
                    print("playerInfoVc - getMatchingInfo() success : matchInnfo.nickname : \(match.nickname)")
                    self.matchInfo = match
             
                case .failure(let error):
                    print("playerInfoVC - getMatchingInfo() failure - error: \(error.rawValue)")
                    self.view.makeToast(error.rawValue, duration: 3.0, position: .center)
                }
            }
    }
    
    
    
}
