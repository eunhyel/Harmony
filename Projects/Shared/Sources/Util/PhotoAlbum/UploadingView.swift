//
//  RemoveVideoPopupView.swift
//

import UIKit
import SwiftyJSON
import Lottie
import Then
import SnapKit

class UploadingView : UIView{
    
    var modal_view = UIView().then {
        $0.backgroundColor = .dimView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        log.d("사진 로딩바 해제")
    }
    
    
    func initialize(){
        self.addSubview(modal_view)
        modal_view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        let uploadAnimation = LottieAnimationView(name: "video_loding", bundle: Bundle(for: Shared.self) ).then{
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .loop
        }
        let uploading_view = UIView().then {
            $0.backgroundColor = .clear
            $0.addSubview(uploadAnimation)
            
            uploadAnimation.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        modal_view.addSubview(uploading_view)
        uploading_view.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(80)
        }
        
        uploadAnimation.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
    }
}
