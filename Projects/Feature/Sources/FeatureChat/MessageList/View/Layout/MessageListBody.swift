//
//  MessageListBody.swift
//  Feature
//
//  Created by root0 on 2023/06/07.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageListBody: UIView {
    var bodyView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var tableView: UITableView = .init(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.separatorStyle = .none
        $0.separatorColor = UIColor(rgbF: 241)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.contentInsetAdjustmentBehavior = .never
        $0.sectionFooterHeight = .leastNormalMagnitude
        $0.bounces = false
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
        
        $0.register(MessageListCell.self, forCellReuseIdentifier: MessageListCell.reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        tableView.separatorStyle = .none
    }
    
    func setLayout() {
        addSubview(bodyView)
        bodyView.addSubview(tableView)
    }
    
    func setConstraint() {
        bodyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    deinit {
        log.d("MessageListBody deinit")
    }
}
