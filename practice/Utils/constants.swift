//
//  constants.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation

enum SEGUE_ID {
    static let USER_ID_VC = "goToUserListVC"
    
    static let PHOTO_COLLECTIONC_VC = "goToPhotoCollectionVC"
    
}

enum API {
    static let BASE_URL : String = "https://api.neople.co.kr/cy/"
        
    static let API_KEY : String = "I5mVNxBmEUhox1JWullCu6zvAgGa5qPO"
}


enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
