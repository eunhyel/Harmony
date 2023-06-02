//
//  ShadowView.swift
//  GlobalYeoboya
//
//  Created by inforex on 2023/01/13.
//  Copyright © 2023 GlobalYeoboya. All rights reserved.
//

import Foundation
import UIKit

public struct ShadowOption {
    var color: UIColor = .black
    var alpha: Float
    var x: CGFloat
    var y: CGFloat
    var blur: CGFloat // 퍼짐 정도
    var spread: CGFloat = 1 // 밖으로 삐져나올 정도
    var radius: CGFloat = 0  // 그림자의 radius
}

open class ShadowView: UIView {
    public var option : ShadowOption?
    
    override open var bounds: CGRect {
        didSet {
            guard let option = option else { return }
            layer.applySketchShadow(option: option)
        }
    }
}
