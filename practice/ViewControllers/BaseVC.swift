//
//  BaseVC.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit

class BaseVC: UIViewController{
    
    var vcTitle : String = "" {
        //  값이 바뀌면 이렇게 설정함
        didSet {
            print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
    
}
