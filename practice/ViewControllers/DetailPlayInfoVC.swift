//
//  DetailPlayInfoVC.swift
//  practice
//
//  Created by 이택성 on 2022/03/16.
//

import UIKit

class DetailPlayInfoVC : BaseVC {

    @IBOutlet weak var DetailPlayInfoTableView: UITableView!

    var gameTypeId : String = ""
    
//    let rank = RankingData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailPlayInfoTableView.delegate = self
        DetailPlayInfoTableView.dataSource = self
        
         
        print("DetailPlayInfoVC - matchDetailInfo : \(matchDetailInfo!.matchID)")
        
        // 데이터베이스 업로드
//        rank.getFirebaseDatabase()

    }
    
    

    
}




extension DetailPlayInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // 셀의 높이를 컨텐츠 크기에 따라 설정
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   // 컨텐츠 크기에 따라 설정.
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailPlayInfoTableViewCell", for: indexPath) as! DetailPlayInfoTableViewCell



        guard let hasMatchinfo = matchDetailInfo else { return cell }


        // 셀에 채울 내용
        switch gameTypeId {
        case "rating" :
            cell.gameTypeId.text = "공식전"
            
        case "normal" :
            cell.gameTypeId.text = "일반전"
            
        default:
            cell.gameTypeId.text = "일반전"
        }
        
        
        cell.map.text = hasMatchinfo.map.name
        cell.date.text = hasMatchinfo.date
        cell.characterName.text = hasMatchinfo.playInfo.characterName
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
        let characterImageURL = URL(string: API.CHARACTER_IMAGE_URL + hasMatchinfo.playInfo.characterId)
        cell.characterImage.kf.setImage(with: characterImageURL)
        
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
        
        return cell
    }
}
