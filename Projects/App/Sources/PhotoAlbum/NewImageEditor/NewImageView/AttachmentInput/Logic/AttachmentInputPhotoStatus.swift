//
//  AttachmentInputPhotoStatus.swift
//  AttachmentInput
//
//  Created by daiki-matsumoto on 2018/02/26.
//  Copyright © 2018 Cybozu, Inc. All rights reserved.
//

import Foundation
import RxSwift

class AttachmentInputPhotoStatus {
    private let statusSubject = BehaviorSubject<Status>(value: .unSelected)

    // Input
    let input: AnyObserver<Status>
    
    // Output
    let output: Observable<Status>
    var status: Status {
        return self.statusSubject.value(Status.unSelected)
    }
    
    init() {
        self.input = self.statusSubject.asObserver()
        self.output = self.statusSubject.asObservable()
    }
    
    enum Status {
        case unSelected
        case loading
        case downloading
        case compressing
        case selected
        case none
    }
}


class AttachmentInputPhotoSelectIndex {
    private let indexSubject = BehaviorSubject<Int>(value: 0)

    // Input
    let input: AnyObserver<Int>
    
    // Output
    let output: Observable<Int>
    var index: Int {
        return self.indexSubject.value(0)
    }
    
    init() {
        self.input = self.indexSubject.asObserver()
        self.output = self.indexSubject.asObservable()
    }
}
