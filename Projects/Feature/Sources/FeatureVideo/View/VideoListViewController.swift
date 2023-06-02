//
//  VideoListViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit

public class VideoListViewController: UIViewController {
    
    var viewModel: VideoListViewModel!
    
    public class func create(with viewModel: VideoListViewModel, preVideoList: [Any]?) -> VideoListViewController {
        
        let vc = VideoListViewController()
        vc.viewModel = viewModel
        return vc
    }
}
