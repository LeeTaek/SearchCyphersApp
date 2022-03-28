//
//  ViewController.swift
//  practice
//
//  Created by 이택성 on 2022/02/22.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {

    
    
    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!

    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: HomeVC.self, action: nil)
   
    
    //MARK: - override method
    override func viewDidLoad() {
        super.viewDidLoad()
 
        print("HomeVC - viewDidLoad() called")
        
        self.config()
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.becomeFirstResponder() // 키보드에 포커싱 주기

    }

    
    
    
    
    
    //MARK: - 값을 다음 화면으로 넘김
    // 다른 화면으로 넘어가기 전에 준비한다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier : \(String(describing: segue.identifier))")
    
        switch segue.identifier {
        case SEGUE_ID.USER_ID_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! UserListVC
            
            guard let userInputValue = self.searchBar.text else { return }
        
            nextVC.vcTitle = userInputValue
            
        case SEGUE_ID.PLAYER_INFO_VC:
            // 다음 화면의 뷰컨트롤러를 가져온다.
            let nextVC = segue.destination as! PlayerInfoVC
            
            guard let userInputValue = self.searchBar.text else { return }
        
            nextVC.vcTitle = userInputValue
        
//        case
        default:
            print("defalut")
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        // 키보드 올라가는 이벤트를 받는 처리
        // 키보드 노티 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        // 키보드 노티 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    //MARK: - fileprivate metohds
    fileprivate func config() {
        
        //UI설정
        self.searchButton.layer.cornerRadius = 10
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        self.keyboardDismissTabGesture.delegate = self
        
        self.view.addGestureRecognizer(keyboardDismissTabGesture)   // 제스처 추가하기
    }
    
    fileprivate func pushVC() {
        var segueId : String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("플레이어 전적 화면으로 이동")
            segueId = "goToPlayerInfoVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "goToUserListVC"
        default:
            print("defalut")
            segueId = "goToPlayerInfoVC"
        }
        
        // 화면 이동
        self.performSegue(withIdentifier: segueId, sender: self)

    }
    
    
    //MARK: - Notification
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShow() called")
        
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("KeyboardSize.height : \(keyboardSize.height)")
            
            // 키보드가 버튼을 덮는 경우
            if (keyboardSize.height < searchButton.frame.origin.y) {
                let distance = keyboardSize.height - searchButton.frame.origin.y
                self.view.frame.origin.y = distance + searchButton.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillHide() called")
        //
        self.view.frame.origin.y = 0
        
    }
    
    
    //MARK: - IBAction methods
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        print("HomeVC - onSearchButtonClicked() called / selected Index : \(searchFilterSegment.selectedSegmentIndex)")
        
        //화면 이동
        pushVC()
    }
    
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
        print("HomeVC - searchFilterValueChanged() called / selected Index : \(sender.selectedSegmentIndex)")
        
     
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "닉네임 "
            
        case 1:
            searchBarTitle = "닉네임"
            
        default:
            searchBarTitle = "닉네임"
        }
        
        self.searchBar.placeholder = searchBarTitle + "입력"
        self.searchBar.becomeFirstResponder()  // 키보드 포커싱을 서치바에
//        self.searchBar.resignFirstResponder() // 포커싱 해제
    }
    
    
    //MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVe - searchBarSearchButtonClicked()")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("🙃 검색 키워드를 입력해주세요", duration: 2.0, position: .top)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("HomeVC - SearchBar textDidchange() searchtext : \(searchText)")
        // 사용자가 입력한 값이 었을때
        if (searchText.isEmpty){
            self.searchButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                // 포커싱 해제
                searchBar.resignFirstResponder()
            })
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    
    
    // 글자 입력을 막음
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        print("shouleChangeTextIn : \(searchBar.text?.appending(text).count)")
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
    
        if (inputTextCount >= 8) {
            self.view.makeToast("🙃 8자까지만 입력 가능합니다", duration: 2.0, position: .top)
        }
        return inputTextCount <= 8
    }
    
    
    
    //MARK: - UIGestureRecognizerDelegate
    // 모든 터치를 감지함.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HomeVC - gestureRecognizer shouldRecieve() called")
        // 터치로 들어온 뷰가 요놈이면
        if (touch.view?.isDescendant(of: searchFilterSegment) == true) {
            print("세그먼트가 터치된다.")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true){
            print("서치바 터치")
            return false
        } else{
            // 편집이 끝나서 키보드가 내려오게 됨
            view.endEditing(true)
            return true
        }
    }
    
}




