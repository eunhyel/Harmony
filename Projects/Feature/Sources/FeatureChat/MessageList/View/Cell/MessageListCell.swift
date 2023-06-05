//
//  MessageListCell.swift
//  Feature
//
//  Created by root0 on 2023/06/05.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

import Shared

class MessageListCell: UITableViewCell {
    static let identifier = "MesssageListCell"
    
    var conatinerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
}
