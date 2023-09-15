//
//  SystemCell.swift
//  Feature
//
//  Created by eunhye on 2023/09/13.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import RxSwift
import Core
import Shared

class SystemTextCell: UITableViewCell {
    
    static let identifier = "SystemTextCell"
    
    var disposeBag = DisposeBag()
    
    lazy var text = UILabel().then {
        $0.text = "ㅇㅇ"
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = .green
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setCommonCell()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func setCommonCell() {
        addComponent()
        setConstraints()
    }
    
    func addComponent() {
        contentView.addSubview(containerView)
        containerView.addSubview(text)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        text.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setUI(_ text : String){
        self.text.text = text
    }
}
