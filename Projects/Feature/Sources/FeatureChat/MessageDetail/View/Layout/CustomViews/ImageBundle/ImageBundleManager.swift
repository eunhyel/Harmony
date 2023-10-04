//
//  ImageBundleManager.swift
//  Feature
//
//  Created by root0 on 2023/10/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageBundleDataSourceDelegate: AnyObject {
    func clickCell(index: Int)
}

class ImageBundleManager: NSObject {
    
    var items: [ImageBundleItem] = []
    
    weak var delegate: ImageBundleDataSourceDelegate?
    
    init(_ urls: [String]?) {
        super.init()
        
        if let urls = urls, !urls.isEmpty {
            self.items = matrixForImageResize(urls: urls)
        }
        
    }
    
    func matrixForImageResize(urls: [String]) -> [ImageBundleItem] {
        var result: [ImageBundleItem] = []
        
        urls.forEach { url in
            result.append(ImageBundleItem(size: .zero, weight: 0, url: url))
        }
        
        return result
    }
    
    func getHeight() -> CGFloat {
        switch items.count {
        case 1: return CGFloat(120)
        case 2: return CGFloat(106)
        case 3: return CGFloat(90)
        default: return CGFloat(120 * 2)
        }
    }
}

extension ImageBundleManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.clickCell(index: indexPath.item)
    }
}

extension ImageBundleManager {
    
    
}


