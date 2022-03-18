//
//  MyError.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import Foundation

enum MyError : String, Error {
    case noContent = "😢 검색 결과가 없습니다."
    case noPlayer = "검색한 닉네임이 존재하지 않습니다🙄"
    case limited8Word = "닉네임은 8글자까지에요‼️"
    case noMatcingRecord = "매칭 기록이 없습니다🤔"
}
