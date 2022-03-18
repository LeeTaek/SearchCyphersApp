//
//  Ranking.swift
//  practice
//
//  Created by 이택성 on 2022/03/17.
//

import Foundation

// MARK: - Ranking
struct Ranking: Codable {
    let rows: [RankRow]
    
}

// MARK: - Row
struct RankRow: Codable {
    let rank: Int
    let playerID, nickname: String
    let grade, ratingPoint: Int
    let clanName: String?

    enum CodingKeys: String, CodingKey {
        case rank
        case playerID = "playerId"
        case nickname, grade, ratingPoint, clanName
    }
}

