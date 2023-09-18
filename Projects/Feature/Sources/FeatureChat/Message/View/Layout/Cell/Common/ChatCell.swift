//
//  ChatCell.swift
//  Feature
//
//  Created by root0 on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

import Shared

protocol ChatCellProtocol: AnyObject {
    var clockView: ChatClockView { get set }
    var profileView: ChatProfileView { get set }
    func addComponents()
    func setConstraints()
    func setIncomingCell(_ continuous: Bool)
    func setOutgoingCell(_ continuous: Bool)
    
    func bind()
    
    var longPress: (() -> Void)? { get }
    var resend: (() -> Void)? { get }
    var openProfile: (() -> Void)? { get }
}
extension ChatCellProtocol {
    
    func setIncomingCell(_ continuous: Bool) {}
    func setOutgoingCell(_ continuous: Bool) {}
    
    func bind() {}
}

typealias ChatCell = UITableViewCell & ChatCellProtocol & Reusable
