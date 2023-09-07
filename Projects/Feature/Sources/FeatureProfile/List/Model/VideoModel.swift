//
//  VideoModel.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import UIKit

struct VideoModel {
    let contentHeightSize: CGFloat
    //let url : URL

    static func getMock(url : [URL]) -> [Self] {

        let minSize : CGFloat = 150    //최소 높이
        var datas: [VideoModel] = []

        let number = 50 // 0 ~ 29   //불러올 갯수
        for i in 0...number {
            let tmpHeight = CGFloat(arc4random_uniform(200))
            let imageHeightSize = tmpHeight < minSize ? minSize : tmpHeight
            let myModel: VideoModel = .init(contentHeightSize: imageHeightSize)//,
                                         //url: url[i])
            datas += [myModel]
        }

        return datas
    }
}
