//
//  MessageViewModel.swift
//  Feature
//
//  Created by root0 on 2023/06/08.
//  Copyright © 2023 Harmony. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Then

import Core
import Shared

struct MessageViewActions {
    typealias justAction = () -> Void
    
    var closeMessageView: justAction?
    var openProfileDetail: ((Any?) -> Void)?
    
}

enum ScrollType {
    case first
    case bottom
    case last
    case none
}

protocol MessageViewModelInput {
    func viewDidLoad()
    func didTapClose()
    func didOpenProfileDetail()
    func setMemberStatusSuccess()
}

protocol MessageMoreViewInput {
    func blockMember()
    func reportMember()
}

protocol MessageMediaViewInput {
    func openPhoto()
    func openCamera()
    func openVideo()
}

protocol MessageViewSendInput {
    func sendTextMessage(text: String) async
    func resendTextMessage(chatMessage: String) // ChatMessage
    func deleteResendMessage(chatMessage: String) // ChatMessage
}

protocol MessageViewSocketInput {
    func sendNewMessage(data: JSON)
    func translateMessage(data: JSON)
}

protocol MessageViewModelOutput {
    var _didListLoad: PublishSubject<ScrollType> { get }
    var _didOpenPhoto: PublishSubject<Void> { get }
    var _didOpenCamera: PublishSubject<Void> { get }
    var _clearInputTextView: PublishSubject<Void> { get }
    
    var _blockMemberResponse: PublishSubject<String> { get }
    var _didOpenDeleteMessagePopup: PublishSubject<Void> { get }
    var _deleteMessageResponse: PublishSubject<Bool> { get }
    
    var _didCanRequestVideoChat: PublishSubject<Void> { get }
    var _showConfirmAlert: PublishSubject<String> { get }
}

protocol MessageViewModel: MessageViewModelInput, MessageViewModelOutput {
    typealias ChatListByDate = [String : [String]]
    typealias ChatDate = [String]
    
    func getChatListByDate() -> ChatListByDate
    func getChatDate() -> ChatDate
    func getSavedChatMessage() -> ChatMessage?
}

class DefaultMessageViewModel: MessageViewModel {
    
    var actions: MessageViewActions?
    
    // MARK: Usecase
    var messageUsecase: Any?
    
    var totalPage: Int = 0
    var pageNo: Int = 1
    static var pagePerCount: Int = 100
    
    var isExistPages: BehaviorRelay<Bool> = .init(value: false)
    
    var chattings: [ChatMessage] = []
    var chatList: ChatListByDate = [:]
    var sectionList: ChatDate = []
    
    var savedTempMessage: ChatMessage?
    
    // MARK: OUTPUT
    var _didListLoad: PublishSubject<ScrollType> = .init()
    var _didOpenPhoto: PublishSubject<Void> = .init()
    var _didOpenCamera: PublishSubject<Void> = .init()
    var _clearInputTextView: PublishSubject<Void> = .init()
    var _blockMemberResponse: PublishSubject<String> = .init()
    var _didOpenDeleteMessagePopup: PublishSubject<Void> = .init()
    var _deleteMessageResponse: PublishSubject<Bool> = .init()
    var _didCanRequestVideoChat: PublishSubject<Void> = .init()
    var _showConfirmAlert: PublishSubject<String> = .init()
    
    init(actions: MessageViewActions? = nil) {
        self.actions = actions
    }
    
    deinit {
        log.d("DefaultMessageViewModel Deinit")
    }
    
}

extension DefaultMessageViewModel {
    
    func viewDidLoad() {
        
    }
    
    func didTapClose() {
        
    }
    
    func didOpenProfileDetail() {
        
    }
    
    func setMemberStatusSuccess() {
        
    }
    
}

extension DefaultMessageViewModel {
    func getChatListByDate() -> ChatListByDate {
        return chatList
    }
    
    func getChatDate() -> ChatDate {
        return sectionList
    }
    
    func getSavedChatMessage() -> ChatMessage? {
        return savedTempMessage
    }
    
}
