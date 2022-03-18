//
//  constants.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation

enum SEGUE_ID {
    static let USER_ID_VC = "goToUserListVC"
    
    static let PLAYER_INFO_VC = "goToPlayerInfoVC"
    
    static let DETAIL_PLAY_INFO_VC = "goToDetailPlayInfoCell"
    
}

enum API {
    static let BASE_URL : String = "https://api.neople.co.kr/cy/"
    
    static let CHARACTER_IMAGE_URL : String = "https://img-api.neople.co.kr/cy/characters/"
        
    static let ATTRIBUTE_IMAGE_URL : String = "https://img-api.neople.co.kr/cy/position-attributes/"
    
    static let RANK_URL : String = "https://api.neople.co.kr/cy/ranking/ratingpoint"
    
    
    static let API_KEY : String = "I5mVNxBmEUhox1JWullCu6zvAgGa5qPO"
    

}


enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}

// 캐릭터 아이디 배열 
enum CharacterId {
    
    static let CHARACTER_ID_ARY = ["c603a74ba02374026a535dc53e5b8d40", "d69971a6762d94340bb2332e8735238a", "4ff1922f862cae2cc98a6d498e76ef2b", "cc357fcea986318e6f6b4fe4501f4a1f",
        "102c0a466e4d5e0e53cdce7f93879d51",
        "fa1340686cb8400dc5a7b0eb291a5a54",
        "bdeafa2ce23cc0d6d301200b1ce5bca9",
        "1bf54947c9c13cd6448940d6ae95ce83",
      
        "384ef5d4bbb43c349d2935fd47c03bb8",
      
        "798afd40efb445158c963b6de2588a6e",
     
        "f414d81d3be548d47d856bfcabd50bce",
        "ea370f7b3d39ab4982cf53bb50e911ec",
     
        "64e6ec54c35e780c45eb2606ddee8914",
     
        "1d5ac6423cc85695a37185c38bb1b528",
        "aa7e0636db959e92f01200c5130f19af",
    
        "5f4c4d6d332766ca219af12dfc41f124",
       
        "cf6008394ebfb5d0de83fa05834018db",
   
        "295c13b63e8af6c2d6bac30eb71455cf",
       
        "89e49e3af689b0e02b700e605153c76e",
     
        "3bc12f4fed260b22fa588f22b7f5abff",
      
        "5908c855eab91d27eb6d996517db1b5b",
     
        "df9599b5be8c37266f7ded9cd2becf60",
    
        "47a1b002f3c601f37cdca060b94a0141",
     
        "163cf60ff617534e051ce4bbc27b91e9",
       
        "13f399bcf8e8aaf0d953ef0e4dc7ef6f",
    
        "f0548e3e7385dd2bc6af26f43ccbc246",
       
        "345130ea32fe807df9588e9bb3cf4759",
       
        "1338a777b6aa275d2856b89390249f42",
                                   
        "a4636e5b1ac646c6f320b53004a34e29",
        
        "796e4f12a5190f0e9ca475db61bb41d0",
       
        "426d56385cd95f08b550b8de937c1cb3",
        
        "8ee3cb8f81baaf745a91dc871b99ff3f",
       
        "caa0168d0c68ec4dfe64d025df2673f0",
    
        "7631b259662ceec42aa035e7c331ab32",
       
        "6d576eca97a6d8255164ff0c2a017d7e",
        
        "5d571cc74e42072a7d3eb49f4f4efb62",
      
        "6d7db858c4f20adcf4fc2eee21c2c03f",
        
        "7d1e6070ba8b5671a5c2373dfa4ffa1c",
        "ec9ab10b0217b0fb008780e90f76261d",
       
        "0c972ec7ba90f52229419f6b44a71c89",
       
        "d672c92b26a858a9ae15bb6e3c510782",
        
        "6b80b807012796e103193c6d88e5def3",
        
        "7dde8c1283f6f920c8337a8d124ce959",
        
        "7685d0e5c2b3a123fd627184c94c5e4d",
       
        "affdeb9a1b0f7185a36db81270ce8c70",
        
        "d6b4e72d01c4b5551b179e8e623b3365",
       
        "a121f236ecffb4508dd208608c3fe2a5",
       
        "052b8ab48199f154cbafc20a8ea7ebcf",
        
        "149913567cfcc642a07e46ad41049da6",
      
        "5ee187dd8ba81f5bb7141688d8aa1c28",
        
        "a76ddf68c94d79db9a9d069f95e0267c",
        
        "e7846625164d88da4f7fef1bc63a8319",
        
        "cc11bb2d8bde801b5661c406297822d9",
        
        "996b051544d11550d4ea409c0e23e624",
       
        "413a78539a67736b9c5ee488e3be68e7",
        
        "0cd5fc051d760e9c1a2f19444ea53917",
        
        "7145eabf772299aaca3b583f3f305fc1",
       
        "bad9955f85d80c68a40673504e67a678",
        
        "c5d2843bedc74035bf487d8c7ece8d23",
       
        "3f4cf1ea927feab0f12bfaf991792f97",
       
        "1fa48342cf3d54343c1d78fbc212210c",
      
        "1e2129fcb1eebba2101ee5de6c4b168a",
      
        "9a00609cb8b9bb8ee9d36a72e822b839",
      
        "d738a9bb4167ff0c4bd36f1bae69f813",
      
        "4408e80fb00f3e4a1e1f27247ca433c9",
        
        "d430ceb55aa87047d92d4cda57e054ca",
       
        "29863fca436fc32196f3b07b1b80d6eb",
       
        "54110c213b92c716f8908c04c06d28bd",
       
        "8ca68ab00e6f2c33220214d720c024ee",
       
        "42ba0da0781020231280624071c3574d",
      
        "627db8b10d95ba73f0d2765130430454",
       
        "6a0ad7d947ed7a89d90d48faac92e724",
       
        "c59a621aa82958d83535c3dec365db98"]
                             
}
