//
//  VideoViewController.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import Shared
import Core
import CallKit

//test
import StoreKit
import SwiftyJSON

open class VideoViewController: UIViewController{
    
    var viewModel : VideoViewModel!
    var videoLayout: VideoLayout!
    var disposeBag: DisposeBag!
    
    var agoraManager: AgoraIOManager?
    var callObserver: CXCallObserver?
    
    public class func create(with viewModel: VideoViewModel) -> VideoViewController {
        let vc = VideoViewController()
        let disposeBag = DisposeBag()
        let layout = VideoLayout()
        
        vc.videoLayout = layout
        vc.viewModel = viewModel
        vc.disposeBag = disposeBag
        
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        videoLayout.viewDidLoad(view: self.view, viewModel: viewModel)
        socketConnect()
        setChat()
        bind()
        //test
//        
//        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//               SKStoreReviewController.requestReview(in: scene)
//           }
        
        
        Toast.video("상대방 연결 이후 가능해요!", controller: self, duration: 5.0)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraManager = nil
        callObserver = nil
        disposeBag = nil
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(rgbF: 39,a: 0.5).cgColor, UIColor(rgbF: 255, a: 0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.4)
        gradientLayer.locations = [0.0, 0.5]
        videoLayout.topShadowView.layer.insertSublayer(gradientLayer, at: 0)
    }

    
    /* socket 연결 */
    func socketConnect(){
        agoraInit() //아고라 프리뷰 필요해서 띄어주고
        
        
        agoraJoin()
    }
    
    
    /* Agora 아고라 연결 */
    func agoraInit(){
        // 연결할땐  화면이 꺼지지 않도록 idleTimerDisabled를 true로
        DeviceManager.setScreenSaver(turnOff: true)
        
        let param = ["" : "" ]  //서버에서 요청할 정보
        let data = JSON()
        //viewModel.sendCallPacket(cmd: .getConnectionInfo, data: param){ [weak self] data in
            let connector = AgoraIOConnector(
                appID: "a3174635e8d044adb95dbba2c43d032b",//data["appID"].stringValue,
                channel: "1234",//data["channelName"].stringValue,
                token: "3f8dcdb70e774d76953c0cec1864d489",//data["token"].stringValue,
                uid: 0,//data["uid"].intValue,
                ptrUID: data["ptrNo"].intValue,
                audioProfile: data["audioScenario"].intValue,
                audioScenario: data["audioProfile"].intValue,
                videoWidth: data["videoWidth"].intValue,
                videoHeight: data["videoHeight"].intValue,
                videoFrameRate: data["videoFrameRate"].intValue,
                lighteningLevel: data["lighteningLevel"].floatValue,
                smoothnessLevel: data["smoothnessLevel"].floatValue,
                rednessLevel: data["rednessLevel"].floatValue,
                type: .video)
            

        //발신자면 큰 화면에 보여줌
            self.agoraManager = .init(connector: connector, localView: self.videoLayout.remoteVideoView, remoteView: self.videoLayout.localVideoView)
            self.videoLayout.localVideoView.isHidden = true
            self.agoraManager?.agoraKit?.startPreview()
        //}
    }
    
    //상대가 수락해서 연결
    func agoraJoin(){
        
    }
    
    
    func removeVideoView(){
        viewModel.socket?.disconnect()
        agoraManager?.exit()
        DeviceManager.setScreenSaver(turnOff: false)
        self.dismiss(animated: false)
    }
}

