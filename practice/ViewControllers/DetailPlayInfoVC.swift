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
    var KARate : Double = 0
    var DRate : Double = 0
    var getCoinRate = 0
    var SCCrate = 0
    
    
    var rankMatchCount = 0
    var rankerInfo = [Row?]()
    var averRate = [String : Double]()
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailPlayInfoTableView.delegate = self
        DetailPlayInfoTableView.dataSource = self
        
        print("DetailPlayInfoVC - matchDetailInfo : \(matchDetailInfo!.matchId)")
        
        
        guard let hasMatchinfo = matchDetailInfo else { return }

        getCharacterByRanker(CharacterId: hasMatchinfo.playInfo.characterId)
    }
    
    
    // 랭커들의 해당 캐릭터 매칭 데이터 호출
    func getCharacterByRanker(CharacterId: String) {
        print("DetailPlayInfoVC - getCharacterByRanker() called - characterId :\(CharacterId)")
        
        database.child("MatchInfoByCharacter").observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary

            do{

                let jsonData = try JSON(value?.value(forKey: CharacterId) ?? [:]).rawData()
                
                print("json done ")
                
                let characterMatch = try JSONDecoder().decode(RankMatchInfo.self, from: jsonData)
                
                self.rankerInfo = characterMatch.matchingData
                self.rankMatchCount = self.rankerInfo.count
                self.averRate = characterMatch.averageRate
              
                self.KARate = self.averRate["KARate"] ?? -1
                self.DRate = self.averRate["DRate"] ?? -1
                self.getCoinRate = Int(self.averRate["getCoinRate"] ?? -1)
                self.SCCrate = Int(self.averRate["SCCrate"] ?? -1)
                
                
                
                DispatchQueue.main.async {
                    self.DetailPlayInfoTableView.reloadData()
                }

          
            } catch {
                print("detailPlayInfoVC - getCharacterByRanker error ")
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
            cell.getCoin.text = "획득 코인 \n" + hasMatchinfo.playInfo.getCoin.description
            cell.spendCoin.text = "소모코인 \n" + hasMatchinfo.playInfo.spendCoin.description
            cell.spendConsumablesCoin.text = "소모품 사용 \n" + hasMatchinfo.playInfo.spendConsumablesCoin.description
            cell.sentinelKillCount.text = "센티넬 킬 \n" + hasMatchinfo.playInfo.sentinelKillCount.description
            cell.demilisherkillCount.text = "철거반 킬 \n" + hasMatchinfo.playInfo.demolisherKillCount.description

            let killasiRate = Double(hasMatchinfo.playInfo.killCount + hasMatchinfo.playInfo.assistCount)

        
            if self.KARate >= killasiRate  {
                cell.playstyleComment.text = "공격에 적극적으로 참여하세요! \n killAssirate : \(String(format: "%.2f", killasiRate)),\n 랭커 평균 :\(String(format: "%.2f", self.KARate))"
            } else {
                cell.playstyleComment.text = "딜러역할을 good! \n killAssirate : \(String(format: "%.2f", killasiRate)),\n 랭커 평균 :\(String(format: "%.2f", self.KARate))" }
            
            if self.DRate >= Double(hasMatchinfo.playInfo.deathCount) {
                cell.deathComment.text = "데스 관리가 필요합니다! \n DeathRate : \(String(format: "%.2f", hasMatchinfo.playInfo.deathCount)),\n 랭커 평균 : \(String(format: "%.2f", self.DRate))"
            } else {
                cell.deathComment.text = "잘 안죽고 있네요. \n DeathRate : \(String(format: "%.2f",  hasMatchinfo.playInfo.deathCount)),\n 랭커 평균 :\(String(format: "%.2f",  self.DRate))" }
            
            
            if self.getCoinRate <= hasMatchinfo.playInfo.getCoin {
                cell.getCoinComment.text = "잘벌고 있어요!\n 랭커 평균 : \(self.getCoinRate)"
            } else {
                cell.getCoinComment.text = "립 좀 먹으면서 해요 \n 랭커 평균 : \(self.getCoinRate)"
            }
            
            if self.SCCrate >= hasMatchinfo.playInfo.spendConsumablesCoin {
                cell.spendCoinComment.text = "좋은데요? 덜아껴도 돼요 \n 랭커 평균 :\(self.SCCrate)"
            } else {
                cell.spendCoinComment.text = "돈 좀 아껴써요  \n 랭커 평균 :\(self.SCCrate)"
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
