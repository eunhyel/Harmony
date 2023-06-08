//
//  GallertPopupView.swift
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift
import Then
import SnapKit

class GalleryPopupView : UIView{
    
    var modal_view = UIView().then {
        $0.backgroundColor = .dimView
    }
    
    var button_view = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    var photo_btn = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("사진 촬영", for: .normal)
        $0.titleLabel?.font = .m15
        $0.setTitleColor(UIColor(rgbF: 48), for: .normal)
    }
    
    var video_btn = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("동영상 촬영", for: .normal)
        $0.titleLabel?.font = .m15
        $0.setTitleColor(UIColor(rgbF: 48), for: .normal)
    }

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
        
        self.addSubview(modal_view)
        modal_view.addSubview(button_view)
        button_view.addSubview(photo_btn)
        button_view.addSubview(video_btn)

        modal_view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        button_view.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(270)
            $0.height.equalTo(100)
        }

        photo_btn.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }

        video_btn.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        bind()
    }

    
    func bind(){
        let without = UITapGestureRecognizer()
        modal_view.addGestureRecognizer(without)
        
        without.rx.event
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.openType!(.none)
                self.removeFromSuperview()
            }
            .disposed(by: bag)
        
        
        photo_btn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.openType!(.photo)
                self.removeFromSuperview()
        }.disposed(by: bag)
        
        video_btn.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.openType!(.video)
                self.removeFromSuperview()
        }.disposed(by: bag)
    }
}
