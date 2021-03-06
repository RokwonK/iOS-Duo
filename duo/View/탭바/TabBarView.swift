//
//  TabBarView.swift
//  duo
//
//  Created by 김록원 on 2021/01/10.
//  Copyright © 2021 김록원. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TabBarView: UIView {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var touchTab : ((Int) -> Void)?
    
    let disposeBag = DisposeBag()
    let basicTintColor = UIColor(displayP3Red: 159/255, green: 166/255, blue: 170/255, alpha: 1)
    let selectedTintColor = UIColor(displayP3Red: 15/255, green: 15/255, blue: 15/255, alpha: 1)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        homeButton.rx.tap.subscribe(onNext : {[weak self] in
            self?.deselectAll()
            self?.homeButton.isSelected = true
            self?.homeButton.tintColor = self?.selectedTintColor
            self?.touchTab?(0)
        }).disposed(by: disposeBag)
        
        chatButton.rx.tap.subscribe(onNext : {[weak self] in
            self?.deselectAll()
            self?.chatButton.isSelected = true
            self?.chatButton.tintColor = self?.selectedTintColor
            self?.touchTab?(1)
        }).disposed(by: disposeBag)
        
        profileButton.rx.tap.subscribe(onNext : {[weak self] in
            self?.deselectAll()
            self?.profileButton.isSelected = true
            self?.profileButton.tintColor = self?.selectedTintColor
            self?.touchTab?(2)
        }).disposed(by: disposeBag)
    }
    
    func deselectAll() {
        homeButton.isSelected = false
        chatButton.isSelected = false
        profileButton.isSelected = false
        
        homeButton.tintColor = basicTintColor
        chatButton.tintColor = basicTintColor
        profileButton.tintColor = basicTintColor
    }

}
