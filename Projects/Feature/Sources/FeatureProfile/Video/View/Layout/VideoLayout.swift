//
//  VideoLayout.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Shared
import RxSwift


class VideoLayout : UIView{
    
    var safetyLayer = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 0, a: 0.7)
    }
    
    //상단 그림자
    var topShadowView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    /* ======= videoView ======= */
    //상대 비디오 뷰
    var remoteVideoView = UIView().then {
        $0.backgroundColor = .white
    }
    
    //내 비디오 뷰
    var localVideoView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 8
    }
    
    //분할모드 뷰
    var divisionView = UIView().then {
        $0.backgroundColor = .yellow
        $0.isHidden = true
    }
    
    //분할모드 상대 비디오 뷰
    var remoteVideoDivisionView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    //분할모드 내 비디오 뷰
    var localVideoDivisionView = UIView().then {
        $0.backgroundColor = .red
    }

    
    
    /* ======= waitingView ======= */
    var waitingView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    let waitLabel = UILabel().then {
        $0.text = "Waiting"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.textColor = UIColor(redF: 106, greenF: 242, blueF: 176)
    }
    
    let waitTimeLabel = UILabel().then {
        $0.text = "00:30"
        $0.font = .systemFont(ofSize: 44, weight: .bold)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.textColor = UIColor(redF: 106, greenF: 242, blueF: 176)
    }
    
    
    
    
    /* ======= TopLeftView ======= */
    let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    let exitBtn = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    
    /* ======= userInfo ======= */
    var infoView = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 0, a: 0.4)
        $0.layer.cornerRadius = 24
    }
    
    let nameLabel = UILabel().then {    //디자인 정렬이 센터..
        $0.text = "GeorgeGeorGeorg"
        $0.font = .m16
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    let genderIcon = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = FeatureAsset.bageFemale.image
    }
    
    let countryIcon = UIImageView().then {
        $0.backgroundColor = .clear
        $0.image = FeatureAsset.icoNation.image
    }
    
    let countryLabel = UILabel().then {
        $0.text = "KOR"
        $0.font = .m16
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    let reportIcon = UIImageView().then {
        $0.backgroundColor = .white
    }
    
    /* ======= localTopView ======= */
    var localVideoTopView = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 0, a: 0.7)
        $0.layer.cornerRadius = 8
    }
    
    let localVideoFoldfBtn = UIButton().then {
        $0.backgroundColor = .white
    }
    
    let timeIcon = UIImageView().then {
        $0.backgroundColor = .white
    }
    
    let timeLabel = UILabel().then {
        $0.text = "00:00"
        $0.font = .m16
        $0.textAlignment = .left
        $0.backgroundColor = .white
    }


    
    /* ======= menuView ======= */
    //메뉴 배치 뷰
    var menuView = UIView().then {
        $0.backgroundColor = .clear
    }

    let chatBtn = UIButton().then {
        $0.backgroundColor = .red
    }
    
    let micBtn = UIButton().then {
        $0.backgroundColor = .yellow
    }
    
    let cameraBtn = UIButton().then {
        $0.backgroundColor = .green
    }
    
    let giftBtn = UIButton().then {
        $0.backgroundColor = .purple
    }
    
    //채팅 입력창
    var chatBarView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let photoBtn = UIButton().then {
        $0.backgroundColor = .purple
    }
    
    let sendBtn = UIButton().then {
        $0.backgroundColor = .purple
    }
    
    var textInput = UITextView().then {
        $0.font = .m15
        $0.textColor = .gray20
        $0.textContainerInset = .zero
        $0.isScrollEnabled = false
        $0.backgroundColor = .black
    }
    
    //하단
    var bottomView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.backgroundColor = .gray
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    var chatTableView : UITableView = .init(frame: .zero, style: .grouped).then {
        $0.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.rowHeight = UITableView.automaticDimension
        $0.sectionFooterHeight = .leastNormalMagnitude
        $0.showsVerticalScrollIndicator = false
    
        $0.register(SystemTextCell.self, forCellReuseIdentifier: SystemTextCell.identifier)
        $0.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        $0.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
    }
    

    func viewDidLoad(view: UIView, viewModel: VideoViewModel) {
        
        view.addSubview(safetyLayer)
        setLayout()
        setConstraint()
        
    }
    
    func setLayout() {
        [remoteVideoView,
         divisionView,
         topShadowView,
         waitingView,
         menuView,
        ].forEach(safetyLayer.addSubview(_:))
        
        [chatTableView,
         localVideoView,
         bottomView,
         infoStackView,
         chatBarView
        ].forEach(menuView.addSubview(_:))
        
        [remoteVideoDivisionView,
         localVideoDivisionView,
        ].forEach(divisionView.addSubview(_:))
        
        
        /* ======= localTopView ======= */
        localVideoView.addSubview(localVideoTopView)
        
        [localVideoFoldfBtn,
         timeIcon,
         timeLabel,
        ].forEach(localVideoTopView.addSubview(_:))

        
        /* ======= TopLeftView ======= */
        [exitBtn, infoView].forEach { infoStackView.addArrangedSubview($0) }
        
        /* ======= userInfo ======= */
        [nameLabel,
         genderIcon,
         countryIcon,
         countryLabel,
         reportIcon,
        ].forEach(infoView.addSubview(_:))
        
        
        /* ======= waitingView ======= */
        [waitLabel,
         waitTimeLabel,
        ].forEach(waitingView.addSubview(_:))
        
        
        /* ======= bottomView ======= */
        [photoBtn,
         textInput,
         sendBtn,
        ].forEach(chatBarView.addSubview(_:))
        
        [chatBtn, micBtn, cameraBtn, giftBtn].forEach { bottomView.addArrangedSubview($0) }

    }
    
    func setConstraint() {
        
        safetyLayer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topShadowView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        
        /* ======= videoView ======= */
        remoteVideoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        localVideoView.snp.makeConstraints {
           $0.top.equalToSuperview().offset(16)
           $0.trailing.equalToSuperview().offset(-16)
           $0.height.equalTo(180)
           $0.width.equalTo(120)
        }
        
        divisionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        remoteVideoDivisionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(DeviceManager.Size.height/2)
        }
        
        localVideoDivisionView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(remoteVideoDivisionView.snp.bottom).offset(-4)
        }
        
        /* ======= TopLeftView ======= */
        infoStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        exitBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        
        /* ======= userInfo ======= */
        infoView.snp.makeConstraints {
            $0.width.equalTo(189)
        }
        
        reportIcon.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(8)
            $0.size.equalTo(32)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(reportIcon.snp.left).offset(-8)
            $0.height.equalTo(16)
        }
        
        genderIcon.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.left.equalToSuperview().inset(16)
            $0.size.equalTo(18)
        }
        
        countryIcon.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.left.equalTo(genderIcon.snp.right).offset(4)
            $0.height.equalTo(18)
            $0.width.equalTo(22)
        }
        
        countryLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.left.equalTo(countryIcon.snp.right).offset(4)
            $0.height.equalTo(16)
        }
        
        
        /* ======= waitingView ======= */
        waitingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        waitLabel.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(173)
        }
        
        waitTimeLabel.snp.makeConstraints {
            $0.top.equalTo(waitLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
            $0.width.equalTo(173)
        }
        
        
        /* ======= localTopView ======= */
        localVideoTopView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        localVideoFoldfBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.right.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
        
        timeIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(18)
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.equalTo(timeIcon.snp.right).offset(4)
            $0.right.equalTo(localVideoFoldfBtn.snp.left).offset(-4)
            $0.top.bottom.equalToSuperview().inset(9)
        }
        
        
        /* ======= menuView ======= */
        menuView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
            $0.left.right.equalToSuperview()
        }

        
        chatTableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-65)
            $0.height.equalTo(225)
            $0.bottom.equalTo(bottomView.snp.top).offset(0)
        }
        
        //하단
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        chatBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        micBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        cameraBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        giftBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
        chatBarView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        photoBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
        
        sendBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(10)
            $0.size.equalTo(20)
        }
        
        textInput.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalTo(photoBtn.snp.right).offset(4)
            $0.right.equalTo(sendBtn.snp.left).offset(-4)
        }
    }
}
