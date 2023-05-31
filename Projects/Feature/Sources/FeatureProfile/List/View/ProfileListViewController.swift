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




open class ProfileListViewController: UIViewController {
    
    
    
    public override func loadView() {
        super.loadView()
        
    }
        
    
    
    class func create(with viewModel: ProfileListViewModel) -> ProfileListViewController {
        
        let vc                = ProfileListViewController()
            
        let disposeBag        = DisposeBag()
        
        let layout            = ProfileListLayout()
        
                
        return vc
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
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
