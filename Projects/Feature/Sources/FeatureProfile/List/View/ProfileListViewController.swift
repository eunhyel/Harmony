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
    
    var dataSource: [VideoModel] = []
    
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
        
        listLayout.collectionView.delegate = self
        listLayout.collectionView.dataSource = self
        listLayout.collectionViewFlowLayout.delegate = self
        
        let url = [URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMjA4MDdfMzQg/MDAxNjU5ODA4NDg3NDk2.8HhF0w7-181YY123fVFGM6GbUpjT56nCSp7Vc5-5RkIg.3wEL822sJQDFf8tJrhaRFIYaXB8FL8PFqCCNCWR3yAkg.JPEG.niceguy00/Seul_%EC%97%90%EC%8A%A4%ED%8C%8C_%EB%8F%84%EA%B9%A8%EB%B9%84%EB%B6%88_%EC%B9%B4%EB%A6%AC%EB%82%9879.jpg?type=w800")!]
        dataSource = VideoModel.getMock(url:url)
        log.d(UserDefaultsManager.deviceID)
        //PhotoViewController.open(controller: self)
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


extension ProfileListViewController: MyCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.item].contentHeightSize
    }
}


extension ProfileListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.id, for: indexPath)
        if let cell = cell as? VideoCell {
            cell.videoModel = dataSource[indexPath.item]
            cell.bind(to: viewModel, indexPath: indexPath)
        }
        return cell
    }
}
