//
//  Kakao.swift
//  Core
//
//  Created by eunhye on 2023/06/09.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKShare
import KakaoSDKTemplate
import Shared
import UIKit

class Kakao {
    
    func initSDKWithAppKey() {
        let keyID = "958e256bd4e9c6084cbb684294c8958b"
        
        KakaoSDK.initSDK(appKey: keyID)
    }
    
    /// 로그인 버튼 눌럿을때 카카오톡 or 카카오계정
    func signUp() {
        // 먼저 로그아웃 처리
        UserApi.shared.logout { error in
            if let error = error {
                log.e("카카오 로그아웃 에러 \(error.localizedDescription)")
            }
            
        }
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    log.e(error.localizedDescription)
                    log.i("카카오톡으로 로그인 실패")
                    //RequestCallbacks.deliveryAccessToken("kakao")
                } else if AuthApi.hasToken() { // 토큰이 이미 있을 때
                    log.d("카카오톡으로 로그인 성공")
                    //RequestCallbacks.deliveryAccessToken("kakao", accessToken: oauthToken?.accessToken)
                } else { // 토큰 없을 때
                    log.i("카카오톡으로 로그인 토큰이 없음")
                    //RequestCallbacks.deliveryAccessToken("kakao")
                }
                
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    log.e(error.localizedDescription)
                    log.i("카카오계정으로 로그인 실패")
                    //RequestCallbacks.deliveryAccessToken("kakao")
                } else if AuthApi.hasToken() { // 토큰이 이미 있을 때
                    log.d("카카오계정으로 로그인 성공")
                    //RequestCallbacks.deliveryAccessToken("kakao", accessToken: oauthToken?.accessToken)
                } else { // 토큰 없을 때
                    log.i("카카오계정으로 로그인 토큰이 없음")
                    // RequestCallbacks.deliveryAccessToken("kakao")
                }
            }
        }
    }
    
    /// 카카오톡 공유 - 카카오톡 친구초대
    func link(_ data : JSON){
        
        let title = data["sendMsg"].stringValue
        var imgUrl = data["imgUrl"].string ?? "http://image.club5678.com/imgs/mobile/141210/cradar_img1.png"
        
        /// 먼저 카카오톡 설치 여부 확인
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 공유 가능
            let link = Link(androidExecutionParams: [:], iosExecutionParams: [:])   //패키지 분기처리
            var btn1 = Button(title: "클럽5678 앱으로", link: link)
            
            let content = Content(title: title, imageUrl: URL(string: imgUrl)!, link: link)
            let feedTemplate = FeedTemplate(content: content, buttons: [btn1])
            
            ShareApi.shared.shareDefault(templatable: feedTemplate) { (sharingResult, error) in
                if let error = error {
                    log.e("error : \(error.localizedDescription)")
                } else {
                    log.d("shareDefault(templateObject:templateJsonObject) success.")
                    guard let sharingResult = sharingResult else { return }
                    UIApplication.shared.open(sharingResult.url)
                }
            }
            
        } else {
            // 카카오톡 미설치 : 웹 공유 사용 권장
            log.e("기기에 카카오톡 미설치")
            //Toast.show("카카오톡을 설치 후 시도해 주세요")
        }
    }
    
}
