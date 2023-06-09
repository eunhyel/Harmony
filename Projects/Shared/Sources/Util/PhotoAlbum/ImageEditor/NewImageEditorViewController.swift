//
//  ImageEditorViewController.swift
//  iosYeoboya
//
//  Created by YuJongCheol on 2017. 12. 5..
//  Copyright © 2017년 inforex. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewImageEditorViewController: UIViewController, NewImageCropViewControllerDelegate  {

    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var allRegistBtn: UIButton!
    
    var swipeVC: NewSwipeViewController!
    var photoVC: PhotoViewController!
    
    // 전달되어 온 데이타들...
    var pageData = [UIImage]()
    var bridgeData: JSON!
    
    var didSelect: (([UIImage]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.previousBtn.addTarget(self, action: #selector(goPrevious), for: .touchUpInside)
        self.nextBtn.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        self.allRegistBtn.addTarget(self, action: #selector(allRegist), for: .touchUpInside)
        
        // 스크롤 데이타가 하나이면 예외처리..
        if self.pageData.count == 1 {
            self.previousBtn.isHidden = true
            self.nextBtn.isHidden = true
            // 스와이프 비활성화.
            for view in self.swipeVC.view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = false
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewSwipeViewController" {
            self.swipeVC = segue.destination as? NewSwipeViewController
            self.swipeVC.pageData = self.pageData
            self.swipeVC.currentPageLabel = self.currentPageLabel
        }
    }
    
    @IBAction func rotateCurrentImage(_ sender: AnyObject) {
        let oldImage = self.swipeVC.currentContentViewController.centerImage.image!
        let newImage = oldImage.imageRotatedByDegrees(90)
        self.swipeVC.currentContentViewController.centerImage.image = newImage      // 뷰어에 바꿔주고.
        self.swipeVC.pageData[self.swipeVC.currentContentViewController.pageIndex] = newImage                    // 가지고있는 데이타도 바꿔주고.
    }
    
    @IBAction func cropCurrentImage(_ sender: AnyObject) {
        let image = self.swipeVC.currentContentViewController.centerImage.image!
        self.presentCropViewController(image, cropRatio: self.bridgeData["getCrop"])
    }
    
    // 크롭뷰컨트롤러 띄우자.
    func presentCropViewController(_ image: UIImage, cropRatio: JSON) {
        guard let cropVC = UIStoryboard(name: "NewImageCrop", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "NewimageCropView") as? NewImageCropViewController else {
            return
        }
        
        cropVC.image = image
        cropVC.delegate = self
        cropVC.modalPresentationStyle = .fullScreen
        self.present(cropVC, animated: false, completion: nil)
    }
    // delegate
    func imageCropViewControllerDidCancel(_ controller: UIViewController!) {
        controller.dismiss(animated: false, completion: nil)
    }
    func imageCropViewControllerSuccess(_ controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        controller.dismiss(animated: false, completion: nil)
        self.swipeVC.currentContentViewController.centerImage.image = croppedImage      // 뷰어 바꿔주고...
        self.swipeVC.pageData[self.swipeVC.currentContentViewController.pageIndex] = croppedImage                    // 가지고있는 데이타도 바꿔주고.
    }
    
    @objc func allRegist() {
        didSelect?(self.swipeVC.pageData)
        self.dismiss(animated: false, completion: nil)
    }
    
    // 에디터 닫고 피커 다시 띄운다.
    @IBAction func cancelEdit(_ sender: AnyObject) {
        // 일단 뷰컨트롤러 내리고.
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func goNext() {
        let index = self.swipeVC.currentContentViewController.pageIndex + 1
        self.swipeVC.goNext(index)
    }
    
    @objc func goPrevious() {
        let index = self.swipeVC.currentContentViewController.pageIndex - 1
        self.swipeVC.goPrevious(index)
    }
    
    
    
    func newCropViewController(_ controller: NewImageCropViewController, didFinishCroppingImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func newCropViewController(_ controller: NewImageCropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        self.swipeVC.currentContentViewController.centerImage.image = image
        self.swipeVC.pageData[self.swipeVC.currentContentViewController.pageIndex] = image
    }
    
}


extension UIImage {
    
    public func imageRotatedByDegrees(_ degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180

        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: radians);
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()

        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        bitmap?.rotate(by: radians)
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}
