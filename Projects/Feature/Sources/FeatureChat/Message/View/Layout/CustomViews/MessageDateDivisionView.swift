//
//  MessageDateDivisionView.swift
//  Feature
//
//  Created by root0 on 2023/09/07.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageDateDivisionView: UICollectionReusableView, Reusable {
    
    var dateWrapper = UIView().then {
        $0.backgroundColor = UIColor(rgbF: 245)
        $0.roundCorners(cornerRadius: 14, maskedCorners: [.allCorners])
    }
    
    var date = UILabel().then {
        $0.textColor = UIColor(rgbF: 99)
        $0.font = .m14
        $0.text = "2023-05-15"
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        date.text = nil
    }
    
    func initView() {
        self.backgroundColor = .white
        
        self.addSubview(dateWrapper)
        dateWrapper.addSubview(date)
    }
    
    func configUI(_ dateStr: String?) {
        
        date.text = dateStr
        
        date.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(7)
        }
        
        dateWrapper.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(2)
        }
    }
    
    func clearConstraints() {
        dateWrapper.snp.removeConstraints()
        date.snp.removeConstraints()
    }
}
