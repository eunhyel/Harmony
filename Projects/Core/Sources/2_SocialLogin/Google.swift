//
//  Google.swift
//  Core
//
//  Created by eunhye on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import GoogleSignIn

class Google: NSObject {

    class var shared : Google {
        struct Static {
            static let instance : Google = Google()
        }
        return Static.instance
    }


    func signIn() {
//        guard let loginVC = App.getTopViewController() as? LoginViewController else { return }
//
        let config = GIDConfiguration(clientID: "994723431532-h8ivktl1i94s95l52boj0dnhcou02vfp.apps.googleusercontent.com")
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: loginVC) { signInResult, error in
//            guard let result = signInResult,
//                  let id = result.user.userID,
//                  let email = result.user.profile?.email else { return }
//
//            self.sendSocialToken(token: id, email: email)
//        }
    }

    private func sendSocialToken(token: String, email: String) {
//        guard let loginVC = App.getTopViewController() as? LoginViewController else { return }
//
//        loginVC.viewModel.webViewManager.requestSocialToken(service: .google,
//                                                            token: token,
//                                                            email: email,
//                                                            responseCallback: nil)
    }
}
