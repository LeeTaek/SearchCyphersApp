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
    let playerID, nickname: String
    let grade: Int

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case nickname, grade
    }
}


// MARK: - UserInfo
struct MatchInfo: Codable {
    let playerID, nickname: String
    let grade: Int
    let clanName: String?
    let ratingPoint, maxRatingPoint: Int?
    let tierName: String?
    let records: [Record]
    let matches: Matches

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case nickname, grade, clanName, ratingPoint, maxRatingPoint, tierName, records, matches
    }
}

// MARK: - Matches
struct Matches: Codable {
    let date: DateClass
    let gameTypeID, next: String
    let rows: [Row]

    enum CodingKeys: String, CodingKey {
        case date
        case gameTypeID = "gameTypeId"
        case next, rows
    }
}

// MARK: - DateClass
struct DateClass: Codable {
    let start, end: String
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
    let mapID, name: String

    enum CodingKeys: String, CodingKey {
        case mapID = "mapId"
        case name
    }
}

// MARK: - PlayInfo
struct PlayInfo: Codable {
    let res: Res
    let random: Bool
    let partyUserCount: Int
    let partyInfo: [PartyInfo]
    let playTypeName: PlayTypeName
    let characterID, characterName: String
    let level, killCount, deathCount, assistCount: Int
    let attackPoint, damagePoint, battlePoint, sightPoint: Int
    let towerAttackPoint, backAttackCount, comboCount, spellCount: Int
    let healAmount, sentinelKillCount, demolisherKillCount, trooperKillCount: Int
    let guardianKillCount, guardTowerKillCount, getCoin, spendCoin: Int
    let spendConsumablesCoin, playTime, responseTime, minLifeTime: Int
    let maxLifeTime: Int

    enum CodingKeys: String, CodingKey {
        case res = "result"
        case random, partyUserCount, partyInfo, playTypeName
        case characterID = "characterId"
        case characterName, level, killCount, deathCount, assistCount, attackPoint, damagePoint, battlePoint, sightPoint, towerAttackPoint, backAttackCount, comboCount, spellCount, healAmount, sentinelKillCount, demolisherKillCount, trooperKillCount, guardianKillCount, guardTowerKillCount, getCoin, spendCoin, spendConsumablesCoin, playTime, responseTime, minLifeTime, maxLifeTime
    }
}

// MARK: - PartyInfo
struct PartyInfo: Codable {
    let playerID, nickname, characterID, characterName: String

    enum CodingKeys: String, CodingKey {
        case playerID = "playerId"
        case nickname
        case characterID = "characterId"
        case characterName
    }
}

enum PlayTypeName: String, Codable {
    case 정상 = "정상"
}

enum Res: String, Codable {
    case lose = "lose"
    case win = "win"
}

// MARK: - Position
struct Position: Codable {
    let name: String
    let explain: Explain
    let attribute: [Attribute]
}

// MARK: - Attribute
struct Attribute: Codable {
    let level: Int
    let id, name: String
}

enum Explain: String, Codable {
    case 주변아군의스킬공격력3방어력4회피4 = "주변 아군의 스킬 공격력 +3%, 방어력 +4%, 회피 +4%"
    case 체력7회피5 = "체력 +7%, 회피 +5%"
    case 치명타피해량12 = "치명타 피해량 +12%"
}

// MARK: - Record
struct Record: Codable {
    let gameTypeID: String
    let winCount, loseCount, stopCount: Int

    enum CodingKeys: String, CodingKey {
        case gameTypeID = "gameTypeId"
        case winCount, loseCount, stopCount
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
