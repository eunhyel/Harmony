//
//  AttachmentInputDelegate.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/03/16.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol AttachmentInputDelegate: class {
    func inputImage(fileURL: URL, image: UIImage, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?)
    func inputMedia(fileURL: URL, fileName: String, fileSize: Int64, fileId: String, imageThumbnail: UIImage?, isVideo: Bool)
    func removeFile(fileId: String)
    func imagePickerControllerDidDismiss()
    func onError(error: Error)
}
