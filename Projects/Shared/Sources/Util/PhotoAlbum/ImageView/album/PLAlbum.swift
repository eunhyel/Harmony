//
//  PLAlbum.swift
//  iosYeoboya
//
//  Created by cschoi724 on 2019/12/12.
//  Copyright © 2019 Inforex. All rights reserved.
//

import UIKit
import Photos

struct PLAlbum {
    var thumbnail: UIImage?
    var title: String = ""
    var numberOfItems: Int = 0
    var collection: PHAssetCollection?
}
