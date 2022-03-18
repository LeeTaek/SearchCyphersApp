//
//  DetailPlayInfoVC.swift
//  practice
//
//  Created by 이택성 on 2022/03/16.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class DetailPlayInfoVC : BaseVC {

    let database = Database.database().reference()

    
    @IBOutlet weak var DetailPlayInfoTableView: UITableView!
    
    var gameTypeId : String = ""
    var killAssiRate : Double = 0
    var deathRate : Double = 0
    var getCoin = 0
    var spendConsumablesCoin = 0
    
    
    var rankMatchCount = 0
    var rankerInfo = [Row?]()
    
    let rank = RankingData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailPlayInfoTableView.delegate = self
        DetailPlayInfoTableView.dataSource = self
        
         
        print("DetailPlayInfoVC - matchDetailInfo : \(matchDetailInfo!.matchId)")
        
//         데이터베이스 업로드
//        rank.getFirebaseDatabase()
        
        
        guard let hasMatchinfo = matchDetailInfo else { return }

        getPlayCommnet(Character: hasMatchinfo.playInfo.characterId)
    }
    
    // killAssi, death rate, 코인 획득, 소모 평균 계산
    func getPlayCommnet(Character: String) {
        print("DetailPlayInfoVC - getPlayComment() called - characterId :\(Character)")
        
        database.child("MatchInfoByCharacter").observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary

            do{

                let jsonData = try JSON(value?.value(forKey: Character)!).rawData()

                print(jsonData)
                let characterMatch = try JSONDecoder().decode([Row].self, from: jsonData)
                
                self.rankMatchCount = characterMatch.count
                self.rankerInfo = characterMatch
                
                // 코멘트 계산
                var sumOfKillAssi: Double = 0
                var sumOfDeath : Double = 0
           

                if !characterMatch.isEmpty {
                    for i in 0..<characterMatch.count {
                        let killAssiByTime = Double((characterMatch[i].playInfo.killCount + characterMatch[i].playInfo.assistCount))/Double(characterMatch[i].playInfo.playTime)

                        let deathByTime = Double(characterMatch[i].playInfo.deathCount) / Double(characterMatch[i].playInfo.playTime)

                        self.getCoin += characterMatch[i].playInfo.getCoin
                        self.spendConsumablesCoin += characterMatch[i].playInfo.spendConsumablesCoin
                        
                        sumOfKillAssi += killAssiByTime
                        sumOfDeath += deathByTime
                        
                        print(characterMatch[i].playInfo.characterName)

                    }

                    self.killAssiRate = sumOfKillAssi * 100 / Double(characterMatch.count)
                    self.deathRate = sumOfDeath * 100 / Double(characterMatch.count)
                    self.getCoin /=  Character.count
                    self.spendConsumablesCoin /= characterMatch.count
                    
       
                    
                    DispatchQueue.main.async {
                        self.DetailPlayInfoTableView.reloadData()
                    }

                } else {
                    print("똥캐라 전적기록이 없습니다 ....")
                }

            } catch {
                print("detailPlayInfoVC - getPlaycomment error ")
            }
        })
    }
    
    
    
    

    
}




extension DetailPlayInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.rankMatchCount + 1
    }

    // 셀의 높이를 컨텐츠 크기에 따라 설정
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   // 컨텐츠 크기에 따라 설정.
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPlayInfoTableViewCell", for: indexPath) as! DetailPlayInfoTableViewCell


            guard let hasMatchinfo = matchDetailInfo else { return cell }

            
            // 셀에 공통으로 채울 내용
            switch gameTypeId {
            case "rating" :
                cell.gameTypeId.text = "공식전"

            case "normal" :
                cell.gameTypeId.text = "일반전"

            default:
                cell.gameTypeId.text = "일반전"
            }

            cell.characterName.text = hasMatchinfo.playInfo.characterName
            let characterImageURL = URL(string: API.CHARACTER_IMAGE_URL + hasMatchinfo.playInfo.characterId)
            cell.characterImage.kf.setImage(with: characterImageURL)

   
            cell.map.text = hasMatchinfo.map.name
            cell.date.text = hasMatchinfo.date
            cell.level.text = "Lv ." +
            hasMatchinfo.playInfo.level.description
            cell.result.text = hasMatchinfo.playInfo.res
            cell.killCount.text = "Kill \n" +  hasMatchinfo.playInfo.killCount.description
            cell.deathCount.text = "Death \n" + hasMatchinfo.playInfo.deathCount.description
            cell.assistCount.text = "Assist \n" + hasMatchinfo.playInfo.assistCount.description
            cell.position.text = hasMatchinfo.position.name
            cell.positionDescription.text = "포지션 기본 버프 : " +  hasMatchinfo.position.explain

            cell.attributeName1.text = hasMatchinfo.position.attribute[0].name
            cell.attributeName2.text = hasMatchinfo.position.attribute[1].name
            cell.attributeName3.text = hasMatchinfo.position.attribute[2].name

            // 특성
            let attributeImageURL1 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[0].id)
            cell.attributeImage1.kf.setImage(with: attributeImageURL1)

            let attributeImageURL2 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[1].id)
            cell.attributeImage2.kf.setImage(with: attributeImageURL2)

            let attributeImageURL3 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[2].id)
            cell.attributeImage3.kf.setImage(with: attributeImageURL3)
            
            // comment
            cell.attackPoint.text = "공격량 \n" +  hasMatchinfo.playInfo.attackPoint.description
            cell.damagedPoint.text = "피해량 \n" + hasMatchinfo.playInfo.damagePoint.description
            cell.responseTime.text = "리스폰타임 \n" + hasMatchinfo.playInfo.responseTime.description
            cell.getCoin.text = "획득 획득 \n" + hasMatchinfo.playInfo.getCoin.description
            cell.spendCoin.text = "소모코인 \n" + hasMatchinfo.playInfo.spendCoin.description
            cell.spendConsumablesCoin.text = "소모품 사용 \n" + hasMatchinfo.playInfo.spendConsumablesCoin.description
            cell.sentinelKillCount.text = "센티넬 킬 \n" + hasMatchinfo.playInfo.sentinelKillCount.description
            cell.demilisherkillCount.text = "철거반 킬 \n" + hasMatchinfo.playInfo.demolisherKillCount.description

            let killassiiRate = Double(hasMatchinfo.playInfo.killCount + hasMatchinfo.playInfo.assistCount) * 100 / Double(hasMatchinfo.playInfo.playTime)
            
            let deathRate = Double(hasMatchinfo.playInfo.deathCount) * 100 / Double(hasMatchinfo.playInfo.playTime)
            
            
            if killassiiRate <= self.killAssiRate {
                cell.playstyleComment.text = "공격에 적극적으로 참여하세요! \n killAssirate : \(String(format: "%.2f", killassiiRate)),\n 랭커 평균 :\(String(format: "%.2f", self.killAssiRate))"
            } else {
                cell.playstyleComment.text = "딜러역할을 good! \n killAssirate : \(String(format: "%.2f", killassiiRate)),\n 랭커 평균 :\(String(format: "%.2f", self.killAssiRate))" }
            
            if deathRate >= self.deathRate {
                cell.deathComment.text = "데스 관리가 필요합니다! \n DeathRate : \(String(format: "%.2f", deathRate)),\n 랭커 평균 : \(String(format: "%.2f", self.deathRate))"
            } else {
                cell.deathComment.text = "잘 안죽고 있네요. \n DeathRate : \(String(format: "%.2f", deathRate)),\n 랭커 평균 :\(String(format: "%.2f", self.deathRate))" }
            
            
            if hasMatchinfo.playInfo.getCoin >= self.getCoin {
                cell.getCoinComment.text = "잘벌고 있어요!\n 랭커 평균 : \(self.getCoin)"
            } else {
                cell.getCoinComment.text = "립 좀 먹으면서 해요 \n 랭커 평균 : \(self.getCoin)"
            }
            
            if hasMatchinfo.playInfo.spendConsumablesCoin <= self.spendConsumablesCoin {
                cell.spendCoinComment.text = "좋은데요? 덜아껴도 돼요 \n 랭커 평균 :\(self.spendConsumablesCoin)"
            } else {
                cell.spendCoinComment.text = "돈 좀 아껴써요  \n 랭커 평균 :\(self.spendConsumablesCoin)"
            }
            
            return cell

            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankerInfoCell", for: indexPath) as! playerInfoCell

        
        guard let hasMatchinfo = self.rankerInfo[indexPath.row-1] else { return cell }
//        let hasMatchinfo = hasData[indexPath.row]
    
        switch gameTypeId {
        case "rating" :
            cell.gameTypeId.text = "공식전"

        case "normal" :
            cell.gameTypeId.text = "일반전"

        default:
            cell.gameTypeId.text = "일반전"
        }

        cell.characterName.text = hasMatchinfo.playInfo.characterName
        let characterImageURL = URL(string: API.CHARACTER_IMAGE_URL + hasMatchinfo.playInfo.characterId)
        cell.characterImage.kf.setImage(with: characterImageURL)


        cell.map.text = hasMatchinfo.map.name
        cell.level.text = "Lv ." +
        hasMatchinfo.playInfo.level.description
        cell.result.text = hasMatchinfo.playInfo.res
        cell.killCount.text = "Kill \n" +  hasMatchinfo.playInfo.killCount.description
        cell.deathCount.text = "Death \n" + hasMatchinfo.playInfo.deathCount.description
        cell.assistCount.text = "Assist \n" + hasMatchinfo.playInfo.assistCount.description
        cell.position.text = hasMatchinfo.position.name
        cell.positionDescription.text = "포지션 기본 버프 : " +  hasMatchinfo.position.explain

        cell.attributeName1.text = hasMatchinfo.position.attribute[0].name
        cell.attributeName2.text = hasMatchinfo.position.attribute[1].name
        cell.attributeName3.text = hasMatchinfo.position.attribute[2].name

        // 특성
        let attributeImageURL1 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[0].id)
        cell.attributeImage1.kf.setImage(with: attributeImageURL1)

        let attributeImageURL2 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[1].id)
        cell.attributeImage2.kf.setImage(with: attributeImageURL2)

        let attributeImageURL3 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[2].id)
        cell.attributeImage3.kf.setImage(with: attributeImageURL3)
            
            
            
        
       
        
        
        return cell

    }
        
        
    
}
