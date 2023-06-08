//
//  AttachmentInputConfiguration.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/09/06.
//  Copyright © 2018 Cybozu. All rights reserved.
//
import UIKit
import SwiftyJSON

public class AttachmentInputConfiguration {
    public var photoQuality: Float = 0.8
    public var videoQuality: UIImagePickerController.QualityType = .type640x480
    public var videoOutputDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("clubVideo", isDirectory: true)
    public var fileSizeLimit: Int64 = 1024 * 1000 * 1000 // 1GB
    public var thumbnailSize = CGSize(width: 128 * UIScreen.main.scale , height:  128 * UIScreen.main.scale)
    public var photoCellCountLimit = 100000
    
    //최대 선택할 수 있는 갯수
    public var maxPhoto = 5
    public var maxVideo = 5
    public var maxSelect = 5
    public var maxFiles = 200  //웹에 올릴 수 있는 최대 갯수
    
    //현재 웹에 올려져 있는 갯수
    public var curPhoto = 0  //웹에 올려져있는 사진 갯수
    public var curVideo = 0  //웹에 올려져있는 사진 갯수
    
    
    public var currentVideoCount = 0
    
    public var maxVideoTime = 60.0
    public var minVideoTime = 10.0
    
    var jsonData = JSON()
    
    var galleryType : galleryType = .all
    
    public init() {}
    
}
