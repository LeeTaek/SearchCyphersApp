//
//  PlayerInfoVC.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit
import Kingfisher
import Toast_Swift
import FirebaseAuth


class PlayerInfoVC: BaseVC {
    
    @IBOutlet weak var PlayerInfoTableView: UITableView!
    
    let segmentIndex = 0 
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
    func getUserID(nickname : String) {

        MyAlamofireManager.shared
            .getUserInfo(searchTerm: nickname) { result in
                switch result {
                case .success(let playerInfo) :
                    print("playerInfoVC - getUserID success : playerId : \(playerInfo.playerId)")
                    
                    self.vcTitle = playerInfo.nickname + "(" + playerInfo.grade.description +  "급)"
                    let playerId = playerInfo.playerId
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
            .getMatchInfo(searchterm: playerId, segmentIndex: segmentIndex, gameTypeID: "rating") { result in
                switch result {
                case .success(let match) :
                    print("playerInfoVc - getMatchingInfo() success : matchInnfo.nickname : \(match.nickname)")
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
    

    
    
    // 다음 VC로 matchDetailInfo의 정보를 넘김
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! DetailPlayInfoVC
        
        guard let hasMatchData = matchDetailInfo else { return }
        
        print("playerInfoVC - prepare() matchDetailInfo : \(hasMatchData.matchId)")

        
        nextVC.matchDetailInfo = hasMatchData
        nextVC.gameTypeId = matchInfo?.matches.gameTypeId ?? ""
        
    }
}




extension PlayerInfoVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return matchInfo?.matches.rows.count ?? 0
    }
    
    // 셀의 높이를 컨텐츠 크기에 따라 설정
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   // 컨텐츠 크기에 따라 설정.

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerInfoCell", for: indexPath) as! playerInfoCell
    
   
        
        guard let hasData = matchInfo else { return cell }
    
        let hasMatchinfo = hasData.matches.rows[indexPath.row]
        
        
        // 셀에 채울 내용
        switch hasData.matches.gameTypeId {
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
        
            
        let characterImageURL = URL(string: API.CHARACTER_IMAGE_URL + hasMatchinfo.playInfo.characterId)
        cell.characterImage.kf.setImage(with: characterImageURL)
        
        let attributeImageURL1 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[0].id)
        cell.attributeImage1.kf.setImage(with: attributeImageURL1)
        
        let attributeImageURL2 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[1].id)
        cell.attributeImage2.kf.setImage(with: attributeImageURL2)
        
        let attributeImageURL3 = URL(string: API.ATTRIBUTE_IMAGE_URL + hasMatchinfo.position.attribute[2].id)
        cell.attributeImage3.kf.setImage(with: attributeImageURL3)
        
        
        
        
                
        return cell

        }

    
    // 클릭한 매칭 정보를 matchDetailInfo에 할당 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 보낼 데이터
        guard let  hasData = matchInfo?.matches.rows[indexPath.row] else {return}
     
        matchDetailInfo = hasData
        print("PlayerInfoVC - tableView() indexpath.row : \(indexPath.row), matchDetailInfo.matchID : \(String(describing: hasData.matchId))")
        
        self.performSegue(withIdentifier: "goToDetailPlayInfoVC", sender: self)

                
    }
    
      
    
}
    
    
    

