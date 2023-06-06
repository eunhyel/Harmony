//
//  GallertPopupView.swift
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift

class GalleryPopupView : UIView{
    
    @IBOutlet weak var another_view: UIView!
    @IBOutlet weak var photo_btn: UIButton!
    @IBOutlet weak var video_btn: UIButton!
    
    var openType: ((galleryType) -> Void)?
    
    let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
            initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(){
        setLayout()
        setView()
        bind()
    }
    
    func setLayout(){
    }
    
    func setView(){

    }

    
    func bind(){
        let without = UITapGestureRecognizer()
        another_view.addGestureRecognizer(without)

        without.rx.event
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { _ in
                self.openType!(.none)
                self.removeFromSuperview()
            }
            .disposed(by: bag)
        
        
        photo_btn.rx.tap
            .bind { (_) in
                self.openType!(.photo)
                self.removeFromSuperview()
        }.disposed(by: bag)
        
        video_btn.rx.tap
            .bind { (_) in
                self.openType!(.video)
                self.removeFromSuperview()
        }.disposed(by: bag)
    }
}
