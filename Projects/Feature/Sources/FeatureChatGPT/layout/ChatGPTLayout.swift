//
//  ChatGPTLayout.swift
//  Feature
//
//  Created by John Park on 2023/03/26.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation
import UIKit
import Then
import SnapKit
import Shared

open class ChatGPTLayout: UIView {
    
    open override var safeAreaInsets: UIEdgeInsets {
        get {
            UIEdgeInsets(top: DeviceManager.Inset.top, left: 0, bottom: DeviceManager.Inset.bottom, right: 0)
        }
    }

    //top
    var topView: UIView!
    var flotingBtn: UIButton!
    var callImageView: UIImageView!
    var titleLabel: UILabel!
    
    //center
    var centerView: UIView!
    var profileView: UIImageView!
    var nameLabel: UILabel!
    var localImageView: UIImageView!
    var localLabel: UILabel!
    var systemLabel: UILabel!
    
    //bottom
    var timeLabel: UILabel!
    var rewardLabel: UILabel!
    var menuStackView: UIStackView!
    var giftBtn: UIButton!
    var mikeBtn: UIButton!
    var exitBtn: UIButton!
    var speakerBtn: UIButton!
    var likeBtn: UIButton!
    
    //right event
    var eventStackView: UIStackView!
    var missionBtn: UIButton!
    var nightMissionBtn: UIButton!
    var nightTimeView: UIView!
    var nightTimeLabel: UILabel!
    var rankBtn: UIButton!
    var boosterBtn: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open override func layoutSubviews() {
        print(safeAreaInsets)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLayout(){
        setTop()
        setCenter()
        setBottom()
    }
    
    public func loadView(){
        setLayout()
    }

    /* ========================= TOP ========================= */
    func setTop() {
        
        topView = UIView().then{ $0.backgroundColor = UIColor(rgb:43) }
        flotingBtn = UIButton().then{ $0.backgroundColor = .clear
                                      $0.setImage(UIImage(named: "icoBack"), for: .normal) }
        callImageView = UIImageView().then{ $0.backgroundColor = .clear
                                            $0.image = UIImage(named: "icoCall") }
        titleLabel = UILabel().then{$0.text = "이엘님과 통화중!"
                                    $0.textColor = .white
                                    $0.setFontBoldSize($0.text!, changedStr: "이엘", changedColor: UIColor(r: 255, g: 48, b: 152))}
        
        addSubview(topView)
        
        [callImageView, titleLabel, flotingBtn].forEach { topView    .addSubview($0) }
        
        setTopConstraints()
    }
    
    func setTopConstraints() {
        
        topView.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaInsets)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        callImageView.snp.makeConstraints{
            $0.top.equalTo(14)
            $0.left.equalTo(15)
            $0.width.equalTo(43)
            $0.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalTo(callImageView.snp.right).offset(8)
            $0.right.equalTo(flotingBtn.snp.left).offset(8)
        }
        
        flotingBtn.snp.makeConstraints{
            $0.top.equalTo(9)
            $0.right.equalTo(-25)
            $0.size.equalTo(57)
        }
    }

    
    /* ========================= CENTER ========================= */

    func setCenter() {
        
        centerView = UIView().then{ $0.backgroundColor = UIColor(r: 62, g: 0, b: 28) }
        profileView = UIImageView().then{ $0.backgroundColor = .clear
                                          $0.layer.borderWidth = 3
                                          $0.image = UIImage(named: "rectangle135")
                                          $0.layer.borderColor = UIColor(r: 117, g: 198, b: 250).cgColor
                                          $0.layer.cornerRadius = 58 }
        nameLabel = UILabel().then{ $0.text = "이엘(여/30세)"
                                    $0.setFontBoldTwoSize($0.text!, changedStr: "이엘", changedColor: UIColor(r: 117, g: 198, b: 250), fontSize: 18.0, twoFontSize: 21.0)}
        localLabel = UILabel().then{ $0.text = "경북 > 포항시 북구"
                                     $0.setFontBoldSize($0.text!, changedStr: $0.text!, changedColor: UIColor(r: 222, g: 222, b: 222)) }
        localImageView = UIImageView().then{ $0.backgroundColor = .clear
                                             $0.image = UIImage(named: "icoGps1") }
        systemLabel = UILabel().then{ $0.text = "연결되었습니다. 즐거운 통화되세요!\n나와 상대방의 전화번호가 남지 않습니다!"
                                      $0.setFontBoldSize($0.text!, changedStr: $0.text!, changedColor: UIColor(r: 86, g: 238, b: 147))
                                      $0.numberOfLines = 0
                                      $0.textAlignment = .center }
        
        addSubview(centerView)
        
        [profileView, nameLabel, localLabel, localImageView, systemLabel].forEach { centerView    .addSubview($0) }
        
        setCenterConstraints()
    }
    
    
    func setCenterConstraints() {
        
        centerView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(61)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(265)
        }
        
        profileView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(centerView.snp.top).offset(17)
            $0.size.equalTo(116)
        }
        
        nameLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileView.snp.bottom).offset(17)
        }
        
        localLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        localImageView.snp.makeConstraints{
            $0.top.equalTo(localLabel.snp.top).offset(2)
            $0.right.equalTo(localLabel.snp.left).offset(-8)
            $0.width.equalTo(11)
            $0.height.equalTo(16)
        }
        
        systemLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(localLabel.snp.bottom).offset(14)
        }
    }
    
    
    /* ========================= BOUTTOM ========================= */

    func setBottom() {

        timeLabel = UILabel().then{ $0.text = "통화시간 : 000분 00초"
                                    $0.setFontBoldSize($0.text!, changedStr: $0.text!, changedColor: UIColor(r: 122, g: 245, b: 13), fontSize: 25.0) }
        rewardLabel = UILabel().then{ $0.text = "(적립금 : 0원)"
                                      $0.setFontBoldSize($0.text!, changedStr: $0.text!, changedColor: UIColor(r: 255, g: 247, b: 18)) }
        nightTimeView = UIView().then{ $0.backgroundColor = UIColor(r: 255, g: 208, b: 70)
                                       $0.layer.cornerRadius = 8 }
        nightTimeLabel = UILabel().then{ $0.text = "120분"
                                         $0.textAlignment = .center
                                         $0.setFontBoldSize($0.text!, changedStr: $0.text!, changedColor: UIColor(r: 34, g: 66, b: 181), fontSize: 11.0)
                                         $0.backgroundColor = .clear}
        
        giftBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "icoPreS"), for: .normal) }
        mikeBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "icoMicOn"), for: .normal) }
        exitBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "btnCallDone"), for: .normal) }
        speakerBtn = UIButton().then{ $0.backgroundColor = .clear
                                      $0.setImage(UIImage(named: "icoSpeakerBasic"), for: .normal) }
        likeBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "icoLove"), for: .normal) }
        
        //evet
        missionBtn = UIButton().then{ $0.backgroundColor = UIColor(r: 255, g: 88, b: 185)
                                      $0.layer.cornerRadius = 8
                                   $0.setImage(UIImage(named: "group1447"), for: .normal) }
        nightMissionBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "imgMissonNightS"), for: .normal) }
        rankBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "icoRankingBasic"), for: .normal) }
        boosterBtn = UIButton().then{ $0.backgroundColor = .clear
                                   $0.setImage(UIImage(named: "boosterBasic"), for: .normal) }
        
        menuStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
            $0.spacing = 3
        }
        
        eventStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.alignment = .trailing
            $0.spacing = 5
        }
        
        nightTimeView.addSubview(nightTimeLabel)
        nightMissionBtn.addSubview(nightTimeView)
        
        [timeLabel, rewardLabel, menuStackView, eventStackView].forEach { self    .addSubview($0) }
        [giftBtn, mikeBtn, exitBtn, speakerBtn, likeBtn].forEach { menuStackView.addArrangedSubview($0) }
        [missionBtn, nightMissionBtn, rankBtn, boosterBtn].forEach { eventStackView.addArrangedSubview($0) }
        
        setBottomConstraints()
    }
    
    func setBottomConstraints() {
        timeLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(centerView.snp.bottom).offset(9)
        }
        
        rewardLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
        }
        
        menuStackView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(22.5)
            $0.right.equalToSuperview().offset(-22.5)
            $0.bottom.equalTo(self.snp.bottom).offset(-15)
            $0.height.equalTo(40)
        }
        
        nightTimeView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        nightTimeLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        missionBtn.snp.makeConstraints{
            $0.width.equalTo(62)
        }
        
        eventStackView.snp.makeConstraints{
            $0.top.equalTo(topView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-15)
            $0.width.equalTo(62)
        }
    }
}

















 extension UIColor {
     convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
         self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
     }
     
    convenience init(rgb: CGFloat, a: CGFloat = 1) {
        self.init(red: rgb / 255.0, green: rgb / 255.0, blue: rgb / 255.0, alpha: a)
    }
}

extension UILabel {
    func setFontBoldSize(_ originStr : String, changedStr : String, changedColor : UIColor, fontSize : CGFloat = 16.0){
        let attributedStr = NSMutableAttributedString(string: originStr)
            attributedStr.addAttribute(.foregroundColor, value: changedColor, range: (originStr as NSString).range(of: changedStr))
            attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: (originStr as NSString).range(of: changedStr))
        self.attributedText = attributedStr
    }
    
    func setFontBoldTwoSize(_ originStr : String, changedStr : String, changedColor : UIColor, fontSize : CGFloat, twoFontSize : CGFloat){
        let attributedStr = NSMutableAttributedString(string: originStr)
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: (originStr as NSString).range(of: originStr))
        attributedStr.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: twoFontSize), range: (originStr as NSString).range(of: changedStr))
        attributedStr.addAttribute(.foregroundColor, value: changedColor, range: (originStr as NSString).range(of: originStr))
        self.attributedText = attributedStr
    }
}
