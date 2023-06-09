//
//  Apple.swift
//  Core
//
//  Created by eunhye on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import AuthenticationServices
import Shared

public class Apple: NSObject{

    /// Apple ID 연동 시도
    public func signIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
                
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sendSocialToken(token: String) {
//        guard let loginVC = App.getTopViewController() as? aController else { return }
//
//        loginVC.viewModel.webViewManager.requestSocialToken(service: .apple,
//                                                            token: token, responseCallback: nil)
    }
}

extension Apple: ASAuthorizationControllerDelegate {
    
    /// Apple ID 연동 성공 시
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        var userIdentifier = ""
        
        switch authorization.credential {
            
        case let credential as ASAuthorizationAppleIDCredential:
            userIdentifier = credential.user
            
            if let email = credential.email {
                //UserDefaultsManager.email = email
            }
            if let firstName = credential.fullName?.givenName {
                //UserDefaultsManager.firstName = firstName
            }
            
        case let credential as ASPasswordCredential:
            userIdentifier = credential.user
            
        default: break
        }
        
        sendSocialToken(token: userIdentifier)
    }
    /// Apple ID 연동 실패 시
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        log.d(error)
        log.d(error.localizedDescription)
        //Toast.show("Please try again later.", controller: )
    }
}

extension Apple: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }
}
