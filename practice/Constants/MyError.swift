//
//  MyError.swift
//  practice
//
//  Created by μ΄νμ± on 2022/02/22.
//

import Foundation

enum MyError : String, Error {
    case noContent = "π’ κ²μ κ²°κ³Όκ° μμ΅λλ€."
    case noPlayer = "κ²μν λλ€μμ΄ μ‘΄μ¬νμ§ μμ΅λλ€π"
    case limited8Word = "λλ€μμ 8κΈμκΉμ§μμβΌοΈ"
    case noMatcingRecord = "λ§€μΉ­ κΈ°λ‘μ΄ μμ΅λλ€π€"
}
