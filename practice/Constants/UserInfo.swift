//
//  userInfo.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation

// MARK: - UserInfo
struct UserInfo: Codable {
    let rows: [PlayerInfo]
}

// MARK: - Row
struct PlayerInfo: Codable {
    let playerId, nickname: String
    let grade: Int


}

struct Rank : Codable {
    let Rank : [String : MatchInfo]
}

// MARK: - UserInfo
struct MatchInfo: Codable {
    let playerId, nickname: String
    let grade: Int
    let clanName: String?
    let ratingPoint, maxRatingPoint: Int?
    let tierName: String?
    let records: [Record]?
    let matches: Matches
}

// MARK: - Matches
struct Matches: Codable {
    let gameTypeId, next: String
    let rows: [Row]
}


// MARK: - Row
struct Row: Codable {
    let date, matchID: String
    let map: Map
    let playInfo: PlayInfo
    let position: Position

    enum CodingKeys: String, CodingKey {
        case date
        case matchID = "matchId"
        case map, playInfo, position
    }
}

// MARK: - Map
struct Map: Codable {
    let name: String
}

// MARK: - PlayInfo
struct PlayInfo: Codable {
    let res: String
    let random: Bool
    let partyUserCount: Int?
    let partyInfo: [PartyInfo]?
    let playTypeName: String
    let characterId, characterName: String
    let level, killCount, deathCount, assistCount: Int
    let attackPoint, damagePoint, battlePoint, sightPoint: Int
    let towerAttackPoint, backAttackCount, comboCount, spellCount: Int
    let healAmount, sentinelKillCount, demolisherKillCount, trooperKillCount: Int
    let guardianKillCount, guardTowerKillCount, getCoin, spendCoin: Int
    let spendConsumablesCoin, playTime, responseTime, minLifeTime: Int
    let maxLifeTime: Int

    enum CodingKeys: String, CodingKey {
        case res = "result"
        case random, partyUserCount, partyInfo, playTypeName, characterId, characterName, level, killCount, deathCount, assistCount, attackPoint, damagePoint, battlePoint, sightPoint, towerAttackPoint, backAttackCount, comboCount, spellCount, healAmount, sentinelKillCount, demolisherKillCount, trooperKillCount, guardianKillCount, guardTowerKillCount, getCoin, spendCoin, spendConsumablesCoin, playTime, responseTime, minLifeTime, maxLifeTime
    }
}

// MARK: - PartyInfo
struct PartyInfo: Codable {
    let playerId, nickname, characterId, characterName: String
}


// MARK: - Position
struct Position: Codable {
    let name: String
    let explain: String
    let attribute: [Attribute]
}

// MARK: - Attribute
struct Attribute: Codable {
    let level: Int
    let id, name: String
}


// MARK: - Record
struct Record: Codable {
    let gameTypeId: String
    let winCount, loseCount, stopCount: Int

}


// MARK: - data -> NsDictionary
extension Encodable {
    
    func encode() throws -> [String:Any] {
        
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
