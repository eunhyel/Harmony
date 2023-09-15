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
    
    //상대 비디오 뷰
    var remoteVideoView = UIView().then {
        $0.backgroundColor = .white
    }
    
    //내 비디오 뷰
    var localVideoView = UIView().then {
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 8
    }
    
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
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .left
        $0.backgroundColor = .white
    }
    
    //상단 그림자
    var topShadowView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    //메뉴 배치 뷰
    var menuView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    
    //상단
    let infoStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    
    let exitBtn = UIButton().then {
        $0.layer.cornerRadius = 24
        $0.backgroundColor = .white
    }
    
    
    //하단
    var bottomView = UIView().then {
        $0.backgroundColor = .yellow
    }
    
    var chatTableView : UITableView = .init(frame: .zero, style: .grouped).then {
        $0.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = .blue
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
         topShadowView,
         menuView,
        ].forEach(safetyLayer.addSubview(_:))
        
        [chatTableView,
         localVideoView,
         bottomView,
         infoStackView,
        ].forEach(menuView.addSubview(_:))
        
        
        [exitBtn].forEach { infoStackView.addArrangedSubview($0) }
        
        localVideoView.addSubview(localVideoTopView)
        
        [localVideoFoldfBtn,
         timeIcon,
         timeLabel,
        ].forEach(localVideoTopView.addSubview(_:))
        
    }
    
    func setConstraint() {
        
        safetyLayer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        remoteVideoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topShadowView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        menuView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DeviceManager.Inset.top)
            $0.bottom.equalToSuperview().inset(DeviceManager.Inset.bottom)
            $0.left.right.equalToSuperview()
        }
         
        localVideoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(180)
            $0.width.equalTo(120)
        }
        
        chatTableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-65)
            $0.height.equalTo(225)
            $0.bottom.equalTo(bottomView.snp.top).offset(0)
        }
        
        //상단
        infoStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        exitBtn.snp.makeConstraints {
            $0.width.equalTo(50)
        }
        
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
        
        //하단
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
}
