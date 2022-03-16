//
//  DetailPlayInfoTableViewCell.swift
//  practice
//
//  Created by 이택성 on 2022/03/16.
//

import UIKit

class DetailPlayInfoTableViewCell: playerInfoCell {

    @IBOutlet weak var attackPoint: UILabel!
    @IBOutlet weak var damagedPoint: UILabel!
    @IBOutlet weak var responseTime: UILabel!
    @IBOutlet weak var playstyleComment: UILabel!
    
    @IBOutlet weak var getCoin: UILabel!
    @IBOutlet weak var spendCoin: UILabel!
    @IBOutlet weak var spendConsumablesCoin: UILabel!
    
    @IBOutlet weak var sentinelKillCount: UILabel!
    @IBOutlet weak var demilisherkillCount: UILabel!
    @IBOutlet weak var coinSpendComment: UILabel!
}
