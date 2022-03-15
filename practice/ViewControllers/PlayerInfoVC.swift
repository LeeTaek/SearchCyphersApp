//
//  PlayerInfoVC.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit
import Kingfisher
import Toast_Swift

class PlayerInfoVC: BaseVC {
    
    @IBOutlet weak var PlayerInfoTableView: UITableView!
    
    
    var matchInfo : MatchInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoCollectionVC - viewDidLoad() called")
        
        PlayerInfoTableView.delegate = self
        PlayerInfoTableView.dataSource = self
        
        let userNickname = self.vcTitle

        getUserID(nickname: userNickname)
    }
    
    
    // playerID request
    func getUserID(nickname : String ) {
        
        MyAlamofireManager.shared
            .getUserInfo(searchTerm: nickname) { result in
                switch result {
                case .success(let playerInfo) :
                    print("playerInfoVC - getUserID success : playerId : \(playerInfo.playerID)")
                    
                    self.vcTitle = playerInfo.nickname + "(" + playerInfo.grade.description +  "급)"
                    let playerId = playerInfo.playerID
                    self.getMatchingInfo(playerId: playerId)
                    
                
                    
                case .failure(let err) :
                    print("playerInfoVC - getUserID failure - error : \(err.rawValue)")
                    self.view.makeToast(err.rawValue, duration: 3.0, position: .center)
                    
                }
            
            }
        
    }
    
    // 매칭 기록 request
    func getMatchingInfo(playerId : String) {
        
        MyAlamofireManager.shared
            .getMatchInfo(searchterm: playerId, gameTypeID: "rating") { result in
                switch result {
                case .success(let match) :
                    print("playerInfoVc - getMatchingInfo() success : matchInnfo : \(match)")
                    self.matchInfo = match
                    
                    DispatchQueue.main.async {
                        self.PlayerInfoTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("playerInfoVC - getMatchingInfo() failure - error: \(error.rawValue)")
                    self.view.makeToast(error.rawValue, duration: 3.0, position: .center)

                }
            }
    }
    
}




extension PlayerInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchInfo?.matches.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerInfoCell", for: indexPath) as! playerInfoCell
    
        
        guard let hasMatchinfo = matchInfo else { return cell }
        
        switch hasMatchinfo.matches.gameTypeID {
        case "rating" :
            cell.gameTypeId.text = "공식전"
            
        case "normal" :
            cell.gameTypeId.text = "일반전"
            
        default:
            cell.gameTypeId.text = "일반전"
        }
        
        cell.map.text = hasMatchinfo.matches.rows[indexPath.row].map.name
        cell.date.text = hasMatchinfo.matches.date.start
        cell.characterName.text = hasMatchinfo.matches.rows[indexPath.row].playInfo.characterName
        cell.level.text = "Lv ." +
        hasMatchinfo.matches.rows[indexPath.row].playInfo.level.description
        cell.result.text = hasMatchinfo.matches.rows[indexPath.row].playInfo.res.rawValue
        cell.killCount.text = "Kill \n" +  hasMatchinfo.matches.rows[indexPath.row].playInfo.killCount.description
        cell.deathCount.text = "Death \n" + hasMatchinfo.matches.rows[indexPath.row].playInfo.deathCount.description
        cell.assistCount.text = "Assist \n" + hasMatchinfo.matches.rows[indexPath.row].playInfo.assistCount.description
        cell.position.text = hasMatchinfo.matches.rows[indexPath.row].position.name
        cell.positionDescription.text = "포지션 기본 버프 : " +  hasMatchinfo.matches.rows[indexPath.row].position.explain.rawValue
        
        cell.attributeName1.text = hasMatchinfo.matches.rows[indexPath.row].position.attribute[0].name
        cell.attributeName2.text = hasMatchinfo.matches.rows[indexPath.row].position.attribute[1].name
        cell.attributeName3.text = hasMatchinfo.matches.rows[indexPath.row].position.attribute[2].name
        
            
        let characterImageURL = URL(string: API.CHARACTER_IMAGE_URL + hasMatchinfo.matches.rows[indexPath.row].playInfo.characterID)
        cell.characterImage.kf.setImage(with: characterImageURL)
        
        let attributeImageURL1 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.matches.rows[indexPath.row].position.attribute[0].id)
        cell.attributeImage1.kf.setImage(with: attributeImageURL1)
        
        let attributeImageURL2 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.matches.rows[indexPath.row].position.attribute[1].id)
        cell.attributeImage2.kf.setImage(with: attributeImageURL2)
        
        let attributeImageURL3 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.matches.rows[indexPath.row].position.attribute[2].id)
        cell.attributeImage3.kf.setImage(with: attributeImageURL3)
        
        
        return cell

            
        }
        
      
    
}
    
    
    

