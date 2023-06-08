//
//  RemoveVideoPopupView.swift
//

import UIKit
import SwiftyJSON
import RxCocoa
import RxSwift

class RemoveVideoPopupView : UIView{
 
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cancel_btn: UIButton!
    @IBOutlet weak var remove_btn: UIButton!
    
    @IBOutlet weak var all_remove_btn: UIButton!
    
    fileprivate var completionHandler : (() -> Void)?
    fileprivate var cancelHandler : (() -> Void)?
    
    var message : String = ""
    var attributeText = NSMutableAttributedString()
    var leftAction : () -> Void = {}
    var rightAction : () -> Void = {}
    var allAction : () -> Void = {}
    var disposbag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(){
        
        if !message.isEmpty {
            textLabel.text = message
        }

        
        let attributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]

        let attributeString = NSMutableAttributedString(string: "전체삭제", attributes: attributes)
        all_remove_btn.setAttributedTitle(attributeString, for: .normal)
        
        
        cancel_btn.rx.tap
            .bind { (_) in
                self.leftAction()
                self.removeFromSuperview()
            }
            .disposed(by: disposbag)
        
        remove_btn.rx.tap
            .bind { (_) in
                self.rightAction()
                self.removeFromSuperview()
            }
            .disposed(by: disposbag)
        
        all_remove_btn.rx.tap
            .bind { (_) in
                self.allAction()
                self.removeFromSuperview()
            }
            .disposed(by: disposbag)
    }
}
