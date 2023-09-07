//
//  ConnectionStatView.swift
//  Shared
//
//  Created by root0 on 2023/09/06.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import SnapKit
import Then

open class ConnectionStatView: CustomView {
    
    enum ConnectStatus {
        case online
        case impossible
        case offline(ago: String)
        
        fileprivate var signal: UIColor {
            switch self {
            case .online: return .systemGreen
            case .impossible: return .systemYellow
            case .offline: return .systemGray
            }
        }
        
        fileprivate var status: String {
            switch self {
            case .online: return "Online"
            case .impossible: return "Impossible"
            case .offline(let ago): return ago
            }
        }
    }
    
    let signal = UIView().then {
        $0.backgroundColor = .systemGray
        $0.roundCorners(cornerRadius: 4, maskedCorners: [.allCorners])
    }
    
    let stat = UILabel().then {
        $0.text = "Offline"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.setCharacterSpacing(-0.5)
        $0.setLineHeight(12)
    }
    
    public init(fontSize: CGFloat) {
        super.init(frame: .zero)
        initView()
        setStatusFont(fontSize)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override open func addComponents() {
        self.backgroundColor = UIColor(rgbF: 0, a: 0.6)
        self.roundCorners(cornerRadius: 10, maskedCorners: [.allCorners])
        
        [signal, stat].forEach(addSubview(_:))
    }
    
    override open func setConstraints() {
        signal.snp.makeConstraints {
            $0.size.equalTo(8)
            $0.centerY.equalToSuperview()
            $0.top.left.equalToSuperview().inset(6)
        }
        
        stat.snp.makeConstraints {
            $0.left.equalTo(signal.snp.right).offset(2)
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(6)
        }
    }
    
    func setConnectStat(_ status: ConnectStatus) {
        signal.backgroundColor = status.signal
        stat.text = status.status
    }
    
    func setStatusFont(_ fontSize: CGFloat) {
        self.roundCorners(cornerRadius: (fontSize + 8) / 2.0, maskedCorners: [.allCorners])
        signal.roundCorners(cornerRadius: (fontSize - 4) / 2.0, maskedCorners: [.allCorners])
        stat.setLineHeight(fontSize)
    }
}
