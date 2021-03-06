//
//  LoginViewController.swift
//  duo
//
//  Created by 김록원 on 2021/02/07.
//  Copyright © 2021 김록원. All rights reserved.
//


import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import CoreData
import RxSwift
import RxCocoa


class LoginViewController: UIViewController {
    
    @IBOutlet weak var kakaoButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupLayer()
        setupUI()
        setupBinding()
    }
    
    
    
    func setupLayer() {
        if #available(iOS 13.0, *) { appleButton.isHidden = false }
        else { appleButton.isHidden = true }
        
        kakaoButton.layer.cornerRadius = 12
        kakaoButton.setShadow(color: UIColor.black.cgColor, width: 1, height: 2, opacity: 0.3, radius: 2.0)
        kakaoButton.backgroundColor = UIColor(displayP3Red: 254/255, green: 229/255, blue: 0/255, alpha: 1)
        
        appleButton.layer.cornerRadius = 12
        appleButton.setShadow(color: UIColor.black.cgColor, width: 1, height: 2, opacity: 0.5, radius: 2.0)
    }
    
    
    
    func setupUI() {
        kakaoButton.rx
            .tap
            .subscribe(onNext : { self.loginWithKakao() })
            .disposed(by: viewModel.disposeBag)
        
        appleButton.rx
            .tap
            .subscribe(onNext : { self.loginWithApple() })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    
    func setupBinding() {
        viewModel.userEntity
            .subscribe(onNext : { [weak self] entity in
                entity?.code == nil ? self?.loginSuccess(userEntity : entity) : self?.loginError(code: entity?.code ?? 0)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    
    private func loginWithKakao() {
        viewModel.socialName = "kakao"
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            AuthApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                UserDefaults.standard.setValue(oauthToken?.accessToken ?? "", forKey: "userToken")
                self?.viewModel.requestUser(social: "kakao")
            }
        }
        else {
            AuthApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                UserDefaults.standard.setValue(oauthToken?.accessToken ?? "", forKey: "userToken")
                self?.viewModel.requestUser(social: "kakao")
            }
        }
    }
    
    
    
    private func loginWithApple() {
        viewModel.socialName = "apple"
    }
    
    
    
    private func loginSuccess(userEntity : UserEntity?) {
        viewModel.saveUser(entity: userEntity)
        UserDefaults.standard.setValue(userEntity?.userToken ?? "", forKey: "userToken")
        
        
        self.dismiss(animated: true)
    }
    
    private func loginError(code : Int) {
        
        switch code {
        case -401:
            let setNicknameView = SetNicknameViewController()
            setNicknameView.setData(socialName: viewModel.socialName)
            self.navigationController?.pushViewController(setNicknameView, animated: true)
        default:
            break
        }
    }
    
}
