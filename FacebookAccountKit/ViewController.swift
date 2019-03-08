//
//  ViewController.swift
//  FacebookAccountKit
//
//  Created by Developer Shishir on 3/6/19.
//  Copyright © 2019 Shishir. All rights reserved.
//

import UIKit
import AccountKit

class ViewController: UIViewController {

    var accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (accountKit == nil){
            accountKit = AKFAccountKit(responseType: .accessToken)
            if (accountKit.currentAccessToken != nil){
                // It means user already verified so take user to the next screen
            }
        }
    }
    
    @IBAction func loginWithPhoneDidTapped(_ sender: Any) {
        loginWithPhone()
    }
    
    func loginWithPhone(){
        let inputState = UUID().uuidString
        
        /*
         let phone = AKFPhoneNumber(countryCode: "+880", phoneNumber: "1784888919")
         let vc = (accountKit?.viewControllerForPhoneLogin(with: phone, state: inputState))!
         */
        let vc = (accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        self.prepareLoginViewController(loginVC: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    
    func loginWithEmail() {
        let inputState = NSUUID().uuidString
        let vc = accountKit!.viewControllerForEmailLogin(withEmail: nil, state: inputState)
        self.prepareLoginViewController(loginVC: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    func prepareLoginViewController(loginVC: AKFViewController) {
        loginVC.enableSendToFacebook = true  // Enable as backup of verificaiton mehtod
        loginVC.enableGetACall = true        // Enable as backup of verification method
        loginVC.whitelistedCountryCodes = ["BD"]
        
        loginVC.delegate = self
        loginVC.uiManager = AKFSkinManager(skinType: .translucent, primaryColor: UIColor.red)
        //UI Theming - Optional
        loginVC.uiManager = AKFSkinManager(skinType: .translucent, primaryColor: UIColor.red)
    }
}

extension ViewController: AKFViewControllerDelegate{
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("Login Success")
        showCurrentAccountHolder()
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        print("Login Failed with Error: " + error.localizedDescription)
    }
    
    /*
        Getting Current Account Holder..............
    */
    func showCurrentAccountHolder(){
        if accountKit != nil {
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken); accountKit.requestAccount {
                (account, error) -> Void in
             
                if let email = account?.emailAddress {
                    print(email)
                }
                else if let phoneNumber = account?.phoneNumber?.phoneNumber{
                    print(phoneNumber)
                }
            }
        }
    }
}

