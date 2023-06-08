//
//  ProfileListViewController.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2022/12/19.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift
import RxGesture

import Shared

open class ProfileListViewController: UIViewController {
    
    var viewModel: ProfileListViewModel!
    var listLayout: ProfileListLayout!
    var disposeBag: DisposeBag!
    
    public override func loadView() {
        super.loadView()
        self.view.backgroundColor = .grayF1
    }
    
    public class func create(with viewModel: ProfileListViewModel) -> ProfileListViewController {
        let vc                = ProfileListViewController()
        let disposeBag        = DisposeBag()
        let layout            = ProfileListLayout()
        layout.disposeBag = disposeBag
        
        vc.viewModel = viewModel
        vc.listLayout = layout
        vc.disposeBag = disposeBag
                
        return vc
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        listLayout.viewDidLoad(view: self.view, viewModel: viewModel)
        bind(to: viewModel)
        
        PhotoViewController.open(controller: self)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // output bind
    func bind(to viewModel: ProfileListViewModel) {
        
        
    }
    
    
    func didReceivePush(){
       
    }
    
    
    deinit {
        log.d("deinit")
    }
}

//import SwiftUI
//
//struct ProfileListVCPreviews: PreviewProvider {
//    static var previews: some View {
//        UIViewControllerPreview {
//            ProfileListViewController()
//        }.previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
//    }
//}
