//
//  MessageQuestionCell.swift
//  Feature
//
//  Created by root0 on 2023/09/15.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Shared

struct LuvTokFAQ {
    
    enum PartOfQuestion {
        case payment
        case savedMoney
        case account
        case report
    }
    
    
    enum QPayment: String, CaseIterable {
        case noCashAfterPay = "결제 후 캐시가 안들어와요"
        case errorWhilePaying = "결제 중 에러가 발생했어요"
    }
    
    enum QSavedMoney: String, CaseIterable {
        case whenComeInSaveMoney = "적립금은 언제 들어오나요?"
        case exchangeMoneyEveryday = "환전은 매일 할 수 있나요?"
        case exchangeMoneyHow = "환전은 어떻게 하나요?"
        case whatTheGrade = "등급은 뭔가요?"
    }
    
    enum QAccount: String, CaseIterable {
        case howWithdrawAccount = "계정은 어떻게 탈퇴하나요?"
    }
    
    enum QReport: String, CaseIterable {
        case foundBug
    }
    
    var part: PartOfQuestion
    
    var title: String {
        switch part {
        case .payment: return "결제"
        case .savedMoney: return "적립금"
        case .account: return "계정"
        case .report: return "신고"
        }
    }
    
    var image: UIImage {
        switch part {
        case .payment: return FeatureAsset.boosterBasic.image
        case .savedMoney: return FeatureAsset.boosterBasic.image
        case .account: return FeatureAsset.boosterBasic.image
        case .report: return FeatureAsset.boosterBasic.image
        }
    }
    
    var questions: [String] {
        switch part {
        case .payment: return QPayment.allCases.map { $0.rawValue }
        case .savedMoney: return QSavedMoney.allCases.map { $0.rawValue }
        case .account: return QAccount.allCases.map { $0.rawValue }
        case .report: return QReport.allCases.map { $0.rawValue }
        }
    }
    
}

class QuestionView: UIView {
    
    let container = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 245)
    }
    
    let title = UILabel().then {
        $0.setCharacterSpacing(-0.5)
        $0.text = "Question"
        $0.font = .r16
    }
    
    let subTitle = UILabel().then {
        $0.setCharacterSpacing(-0.5)
        $0.text = "Question"
        $0.font = .r10
    }
    
    let questionImage = UIImageView().then {
        $0.image = nil
    }
    
    let questionContainer = UIView().then {
        $0.backgroundColor = .green
    }
    
    let questionStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
        $0.distribution = .fillEqually
    }
    
    let question = UILabel().then {
        $0.font = .r15
        $0.setCharacterSpacing(-0.5)
        $0.backgroundColor = .white
        $0.textColor = .black
    }
    
    var faq: LuvTokFAQ
    
    init(faq: LuvTokFAQ) {
        self.faq = faq
        super.init(frame: .zero)
        addComponent()
        setConstraints()
        configUI(faq)
    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponent() {
        self.addSubview(container)
        
        [title, subTitle, questionImage, questionContainer]
            .forEach(container.addSubview(_:))
        
        questionContainer.addSubview(questionStack)
        
    }
    
    func setConstraints() {
        container.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        questionImage.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(30)
        }
        
        title.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        
        subTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.top.equalTo(title.snp.bottom).offset(8)
        }
        
        questionContainer.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
        }
        
        questionStack.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    func configUI(_ model: LuvTokFAQ) {
        title.text = model.title
        subTitle.text = model.title
        questionImage.image = model.image
        
        model.questions.forEach { str in
            let q = UILabel()
            q.text = str
            q.setCharacterSpacing(-0.5)
            q.backgroundColor = .white
            q.font = .r12
            
            questionStack.addArrangedSubview(q)
        }
        
    }
}

class MessageQuestionCell: UITableViewCell, Reusable {
    
    let container = UIView()
    
    var profileView = ChatProfileView().then {
        $0.isHidden = false
    }
    
    let bubbleScroll = UIScrollView().then {
        $0.backgroundColor = .brown
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
    }
    
    private var dBag = DisposeBag()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponent()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addComponent() {
        contentView.addSubview(container)
        
        container.addSubview(profileView)
        
        [bubbleScroll]
            .forEach(container.addSubview(_:))
    }
    
    func setConstraints() {
        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
        }
        
        bubbleScroll.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.bottom.equalToSuperview()
        }
        
        [LuvTokFAQ(part: .payment), LuvTokFAQ(part: .savedMoney), LuvTokFAQ(part: .account), LuvTokFAQ(part: .report)].enumerated().forEach { faqSect in
            let qv = QuestionView(faq: faqSect.element)
            let xOffset = 180 * CGFloat(faqSect.offset)
            
            bubbleScroll.addSubview(qv)
            qv.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(xOffset)
                $0.top.bottom.equalToSuperview()
                $0.trailing.lessThanOrEqualToSuperview()
                $0.width.equalTo(180)
                $0.height.equalToSuperview()
            }
        }
        
//        [UIColor.red, .yellow, .blue, .purple].enumerated()
//            .forEach {
//                let qv = QuestionView()
//                qv.backgroundColor = $0.element
//
//                let xOffset = 180 * CGFloat($0.offset)
//
//                bubbleScroll.addSubview(qv)
//                qv.snp.makeConstraints {
//                    $0.leading.equalToSuperview().inset(xOffset)
//                    $0.width.equalTo(180)
//                    $0.height.equalTo(200)
//                }
//        }
        
        bubbleScroll.contentSize.width = 180 * 4
        
        bubbleScroll.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(56)
            $0.trailing.equalToSuperview().inset(-16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    func configUI() {
        profileView.name.text = "관리자"
        profileView.thumbnail.image = FeatureAsset.msgService.image
        
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [profileView]
            .forEach { $0.snp.removeConstraints() }
        
        profileView.isHidden = false
        
    }
    
}
