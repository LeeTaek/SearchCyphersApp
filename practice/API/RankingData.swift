////
////  RankingData.swift
////  practice
////
////  Created by 이택성 on 2022/03/17.
////
////
import Foundation
import Alamofire
import FirebaseDatabase


// Ranking 과 캐릭터 데이터 Friebase Database에 업로드하기 위한 Class 
final class RankingData {

    init() {
        
    }

    var matchDataByCharacter = [String : Row]()
    
    let database = Database.database().reference()

    // firebase를 통한 ranker 데이터 가져와 데이터에 업로드
    func getFirebaseDatabase() {
            print("getFirebaseDatabase() called ")

            database.child("Rank").observeSingleEvent(of: .value, with: { snapshot in
                    
                guard let value = snapshot.value  else { return }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    
                    let rankerMatch = try JSONDecoder().decode([MatchInfo].self, from: jsonData)
                    
                    print("getFirebaseDatabase() - rankerData.count : \(rankerMatch[0].nickname)")
                    
                    // 캐릭터 데이터 업로드
//                    for i in 0..<CharacterId.CHARACTER_ID_ARY.count {
//                        self.sortCharacterID(CharacterId: CharacterId.CHARACTER_ID_ARY[i], matchData: rankerMatch)
//                    }
              
                } catch {
                    print("getFirebaseDatabase() 에러입니당 : \(error.localizedDescription)")
                }
            })
    }
    
    
    
    // 캐릭터별로 항목을 Firebase Database에 업로드
    func sortCharacterID(CharacterId : String, matchData : [MatchInfo] ) {
        
        var count = 0
        for i in 0..<30 {
            for j in 0..<30 {
                if matchData[i].matches.rows[j].playInfo.characterId == CharacterId {
                    
                    self.matchDataByCharacter.updateValue(matchData[i].matches.rows[j], forKey: "\(count)")
                    count += 1
                  
                }
            }
        }
        
        do {
            let rankData = try self.matchDataByCharacter.encode()
        
            self.database.child("MatchInfoByCaracter/\(CharacterId)").setValue(rankData)
            
        } catch {
            print(error)
        }
      
    }

    
    
    
}


