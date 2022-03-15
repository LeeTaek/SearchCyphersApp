//
//  UserList.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit

class UserListVC : BaseVC {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userListVc - viewDidLoad() called")
        
        requestUserAPI()
        
    }
    
    
    //MARK: - request API
    func requestUserAPI() {
        MyAlamofireManager.shared.getUserInfo(searchTerm: vcTitle, completion: { result in

             switch result {
             case .success(let fetchedPlayer):
                 print("HomeVC - getPlayers.success - fetchedPlayer.count : \(fetchedPlayer)")
             case .failure(let error):
                 print("HomeVC - getPlayers.failure = error : \(error.rawValue)")
             }
         })
        
    }
}
