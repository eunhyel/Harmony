//
//  VideoListViewController.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Then
import Shared

public class VideoListViewController: UIViewController {
    
    var viewModel: VideoListViewModel!
    var listLayout: VideoListLayout!
    var disposeBag: DisposeBag!
    
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .grayF1
    }
    
    public class func create(with viewModel: VideoListViewModel, preVideoList: [Any]?) -> VideoListViewController {
        
        let vc = VideoListViewController()
        let disposeBag = DisposeBag()
        let layout = VideoListLayout()
        layout.disposeBag = disposeBag
        
        vc.viewModel = viewModel
        vc.listLayout = layout
        vc.disposeBag = disposeBag
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        listLayout.viewDidLoad(view: self.view, viewModel: viewModel)
        bind(to: viewModel)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        log.d("deinit")
    }
    
    // output
    func bind(to viewModel: VideoListViewModel) {
        
    }
}
