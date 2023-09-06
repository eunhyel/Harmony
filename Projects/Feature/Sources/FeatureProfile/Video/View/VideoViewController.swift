//
//  VideoViewController.swift
//  Feature
//
//  Created by eunhye on 2023/09/04.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import Shared
import Core

open class VideoViewController: UIViewController {
    
    var viewModel : VideoViewModel!
    var videoLayout: VideoLayout!
    var disposeBag: DisposeBag!
    
    var agoraManager: AgoraIOManager?
    
    public class func create(with viewModel: VideoViewModel) -> VideoViewController {
        let vc = VideoViewController()
        let disposeBag = DisposeBag()
        let layout = VideoLayout()
        layout.disposeBag = disposeBag
        
        vc.videoLayout = layout
        vc.viewModel = viewModel
        vc.disposeBag = disposeBag
        
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        videoLayout.viewDidLoad(view: self.view, viewModel: viewModel)
    }
}
