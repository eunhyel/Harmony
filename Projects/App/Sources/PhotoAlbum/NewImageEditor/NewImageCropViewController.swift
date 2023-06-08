//
//  NewCropViewController.swift
//  chat-radar
//
//  Created by eunhye on 2021/05/24.
//  Copyright © 2021 inforex. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import Shared

protocol NewImageCropViewControllerDelegate: class {
    func newCropViewController(_ controller: NewImageCropViewController, didFinishCroppingImage image: UIImage)
    func newCropViewController(_ controller: NewImageCropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect)
}

class NewImageCropViewController: UIViewController {


    @IBOutlet weak var save_crop: UIButton!
    @IBOutlet weak var cropImage_imageView: UIImageView!
    @IBOutlet weak var crop_view: UIView!
    
    @IBOutlet weak var original_tap: UIStackView!
    @IBOutlet weak var ratio_tap2: UIStackView!
    @IBOutlet weak var ratio_tap3: UIStackView!
    @IBOutlet weak var ratio_tap4: UIStackView!
    
    @IBOutlet weak var original_view: UIView!
    @IBOutlet weak var ratio_2_view: UIView!
    @IBOutlet weak var ratio_3_view: UIView!
    @IBOutlet weak var ratio_4_view: UIView!
    
    @IBOutlet weak var original_label: UILabel!
    @IBOutlet weak var ratio_2_label: UILabel!
    @IBOutlet weak var ratio_3_label: UILabel!
    @IBOutlet weak var ratio_4_label: UILabel!
    
    
    var image = UIImage()
    
    let bag = DisposeBag()
    
    fileprivate var cropView: CropView?
    open weak var delegate: NewImageCropViewControllerDelegate?
    
    let selectColor = UIColor.black //UIColor(r: 255, g: 68, b: 114)
    let unselectColor = UIColor.black //UIColor(r: 255, g: 255, b: 255)
    
    var originSize : CGRect!
    
    override func viewDidLoad() {
        
        original_view.layer.borderWidth = 2
        original_view.layer.cornerRadius = 4
        original_view.layer.borderColor = selectColor.cgColor
        
        ratio_2_view.layer.borderWidth = 2
        ratio_2_view.layer.cornerRadius = 4
        ratio_2_view.layer.borderColor = unselectColor.cgColor
        
        ratio_3_view.layer.borderWidth = 2
        ratio_3_view.layer.cornerRadius = 4
        ratio_3_view.layer.borderColor = unselectColor.cgColor
        
        ratio_4_view.layer.borderWidth = 2
        ratio_4_view.layer.cornerRadius = 4
        ratio_4_view.layer.borderColor = unselectColor.cgColor
        
        
        original_label.textColor = selectColor
        ratio_2_label.textColor = unselectColor
        ratio_3_label.textColor = unselectColor
        ratio_4_label.textColor = unselectColor
        
        setCropView()
        bind()
    }
    
    func setCropView(){
        cropView = CropView(frame: crop_view.bounds)
        cropView?.image = image
        cropView?.rotationGestureRecognizer.isEnabled = false
        crop_view.addSubview(cropView!)
        
        DispatchQueue.main.async {
            guard let cropRect = self.cropView?.cropRect else {
                return
            }
            
            self.originSize = cropRect
            log.d(cropRect)
        }
    }

    
    func bind(){
        
        let original_tap = UITapGestureRecognizer()
        let ratio_tap2 = UITapGestureRecognizer()
        let ratio_tap3 = UITapGestureRecognizer()
        let ratio_tap4 = UITapGestureRecognizer()
        
        self.original_tap.addGestureRecognizer(original_tap)
        self.ratio_tap2.addGestureRecognizer(ratio_tap2)
        self.ratio_tap3.addGestureRecognizer(ratio_tap3)
        self.ratio_tap4.addGestureRecognizer(ratio_tap4)
        
        
        original_tap.rx.event
            .bind { (_) in
                self.original_view.layer.borderColor = self.selectColor.cgColor
                self.ratio_2_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_3_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_4_view.layer.borderColor = self.unselectColor.cgColor
                
                self.original_label.textColor = self.selectColor
                self.ratio_2_label.textColor = self.unselectColor
                self.ratio_3_label.textColor = self.unselectColor
                self.ratio_4_label.textColor = self.unselectColor

                self.cropView?.resetCropRect()
                self.cropView?.cropRect = self.originSize
            }.disposed(by: bag)
        
        ratio_tap2.rx.event
            .bind { (_) in
                self.original_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_2_view.layer.borderColor = self.selectColor.cgColor
                self.ratio_3_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_4_view.layer.borderColor = self.unselectColor.cgColor
                
                
                self.original_label.textColor = self.unselectColor
                self.ratio_2_label.textColor = self.selectColor
                self.ratio_3_label.textColor = self.unselectColor
                self.ratio_4_label.textColor = self.unselectColor
                
                var cropSize:CGFloat = 0.0
                if Int((self.cropView?.cropRect.size.width)!) < Int((self.cropView?.cropRect.size.height)!) {
                    cropSize = (self.cropView?.cropRect.size.width)!
                }
                else {
                    cropSize = (self.cropView?.cropRect.size.height)!
                }
                
                if var cropRect = self.cropView?.cropRect {
                    cropRect.size = CGSize(width: cropSize, height: cropSize)
                    cropRect.center = (self.cropView?.cropRect.center)!
                    self.cropView?.cropRect = cropRect
                }
            }.disposed(by: bag)
        
        ratio_tap3.rx.event
            .bind { (_) in
                self.original_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_2_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_3_view.layer.borderColor = self.selectColor.cgColor
                self.ratio_4_view.layer.borderColor = self.unselectColor.cgColor
                
                
                self.original_label.textColor = self.unselectColor
                self.ratio_2_label.textColor = self.unselectColor
                self.ratio_3_label.textColor = self.selectColor
                self.ratio_4_label.textColor = self.unselectColor
                
                if Int((self.cropView?.cropRect.size.width)!) < Int((self.cropView?.cropRect.size.height)!) {
                    let ratio: CGFloat = 3.0 / 4.0
                    if var cropRect = self.cropView?.cropRect {
                        let width = cropRect.width
                        cropRect.size = CGSize(width: width, height: width * ratio)
                        cropRect.center = (self.cropView?.cropRect.center)!
                        self.cropView?.cropRect = cropRect
                    }
                }
                else{
                    let ratio: CGFloat = 4.0 / 3.0
                    if var cropRect = self.cropView?.cropRect {
                        let width = cropRect.height
                        cropRect.size = CGSize(width: width * ratio, height: width)
                        cropRect.center = (self.cropView?.cropRect.center)!
                        self.cropView?.cropRect = cropRect
                    }
                }
            }.disposed(by: bag)
        
        ratio_tap4.rx.event
            .bind { (_) in
                self.original_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_2_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_3_view.layer.borderColor = self.unselectColor.cgColor
                self.ratio_4_view.layer.borderColor = self.selectColor.cgColor
                
                
                self.original_label.textColor = self.unselectColor
                self.ratio_2_label.textColor = self.unselectColor
                self.ratio_3_label.textColor = self.unselectColor
                self.ratio_4_label.textColor = self.selectColor

                if Int((self.cropView?.cropRect.size.width)!) < Int((self.cropView?.cropRect.size.height)!) {
                    let ratio: CGFloat = 3.0 / 4.0
                    if var cropRect = self.cropView?.cropRect {
                        cropRect.size = CGSize(width: cropRect.width * ratio, height: cropRect.height)
                        cropRect.center = (self.cropView?.cropRect.center)!
                        self.cropView?.cropRect = cropRect
                    }
                }
                else{
                    let ratio: CGFloat = 3.0 / 4.0
                    if var cropRect = self.cropView?.cropRect {
                        cropRect.size = CGSize(width: cropRect.height * ratio, height: cropRect.height)
                        cropRect.center = (self.cropView?.cropRect.center)!
                        self.cropView?.cropRect = cropRect
                    }
                }
            }.disposed(by: bag)
        
        
        save_crop.rx.tap
            .bind { (_) in
                if let image = self.cropView?.croppedImage {
                    self.delegate?.newCropViewController(self, didFinishCroppingImage: image)
                    guard let rotation = self.cropView?.rotation else {
                        return
                    }
                    guard let rect = self.cropView?.zoomedCropRect() else {
                        return
                    }
                    self.delegate?.newCropViewController(self, didFinishCroppingImage: image, transform: rotation, cropRect: rect)
                }
            }.disposed(by: bag)
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CGRect {
    /** Creates a rectangle with the given center and dimensions
     - parameter center: The center of the new rectangle
     - parameter size: The dimensions of the new rectangle
     */
    init(center: CGPoint, size: CGSize)
    {
        self.init(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
    }
    
    /** the coordinates of this rectangles center */
    var center: CGPoint
    {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    /** the x-coordinate of this rectangles center
     - note: Acts as a settable midX
     - returns: The x-coordinate of the center
     */
    var centerX: CGFloat
    {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    /** the y-coordinate of this rectangles center
     - note: Acts as a settable midY
     - returns: The y-coordinate of the center
     */
    var centerY: CGFloat
    {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
}
