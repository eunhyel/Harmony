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

public struct MessageViewActions {
    typealias justAction = () -> Void
    
    var closeMessageView: justAction?
    var openProfileDetail: ((Any?) -> Void)?
    
}

public enum ScrollType {
    case first
    case bottom
    case last
    case none
}

public protocol MessageViewModelInput {
    func viewDidLoad()
    func didTapClose()
    func didOpenProfileDetail()
    func setMemberStatusSuccess()
}

public protocol MessageMoreViewInput {
    func blockMember()
    func reportMember()
}

public protocol MessageMediaViewInput {
    func openPhoto()
    func openCamera()
    func openVideo()
}

public protocol MessageViewSendInput {
    func sendTextMessage(text: String) async
    func resendTextMessage(chatMessage: String) // ChatMessage
    func deleteResendMessage(chatMessage: String) // ChatMessage
}

public protocol MessageViewSocketInput {
    func sendNewMessage(data: JSON)
    func translateMessage(data: JSON)
}

public protocol MessageViewModelOutput {
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

public protocol MessageViewModel: MessageViewModelInput, MessageViewModelOutput {
    typealias ChatListByDate = [String : [ChatMessage]]
    typealias ChatDate = [String]
    
    func getChatListByDate() -> ChatListByDate
    func getChatDate() -> ChatDate
    func getSavedChatMessage() -> ChatMessage?
}

public class DefaultMessageViewModel: MessageViewModel {
    
    var actions: MessageViewActions?
    
    // MARK: Usecase
    var memberUseCase: FetchMemberUseCase
    var messageUsecase: FetchMessageUseCase
    
    var totalPage: Int = 0
    var pageNo: Int = 1
    static var pagePerCount: Int = 100
    
    var isExistPages: BehaviorRelay<Bool> = .init(value: false)
    
    var chattings: [ChatMessage] = []
    var chatList: ChatListByDate = [:]
    var sectionList: ChatDate = []
    
    var savedTempMessage: ChatMessage?
    
    // MARK: OUTPUT
    public var _didListLoad: PublishSubject<ScrollType> = .init()
    public var _didOpenPhoto: PublishSubject<Void> = .init()
    public var _didOpenCamera: PublishSubject<Void> = .init()
    public var _clearInputTextView: PublishSubject<Void> = .init()
    public var _blockMemberResponse: PublishSubject<String> = .init()
    public var _didOpenDeleteMessagePopup: PublishSubject<Void> = .init()
    public var _deleteMessageResponse: PublishSubject<Bool> = .init()
    public var _didCanRequestVideoChat: PublishSubject<Void> = .init()
    public var _showConfirmAlert: PublishSubject<String> = .init()
    
    public init(actions: MessageViewActions? = nil,
                memberUseCase: FetchMemberUseCase, messageUseCase: FetchMessageUseCase) {
        self.actions = actions
        
        self.memberUseCase = memberUseCase
        self.messageUsecase = messageUseCase
    }
    
    deinit {
        log.d("DefaultMessageViewModel Deinit")
    }
    
}

// MARK: - Input. View Event Methods
extension DefaultMessageViewModel {
    
    public func viewDidLoad() {
        Task {
            await setChattingData()
        }
    }
    
    public func didTapClose() {
        actions?.closeMessageView?()
    }
    
    public func didOpenProfileDetail() {
        
    }
    
    public func setMemberStatusSuccess() {
        
    }
    
}

extension DefaultMessageViewModel {
    public func getChatListByDate() -> ChatListByDate {
        return chatList
    }
    
    public func getChatDate() -> ChatDate {
        return sectionList
    }
    
    public func getSavedChatMessage() -> ChatMessage? {
        return savedTempMessage
    }
    
    func setChattingData() async {
        do {
            await getPtrUserInfo()
            await loadMessage(.first)
            
        } catch {
            log.e("error -> \(error.localizedDescription)")
            self.errorControl(error)
        }
    }
    
    func getPtrUserInfo() async {
        log.i("[ usecase ] Member : partner Info")
        let ptrInfoTask = Task {
//            try await self.memberUseCase.mexecute(reqModel: 20)
            try await self.mexecute_User(reqModel: 20)
        }
        
        do {
            
            let ptrInfo = try await ptrInfoTask.value
            
            log.d("== PtrInfo From JSON :: \(ptrInfo) ==")
            
        } catch {
            log.e("error -> \(error.localizedDescription)")
        }
        
    }
    
    func loadMessage(_ type: ScrollType = .bottom) async {
        log.i("[ usecase ] Message : list")
        let loadMsg = Task {
//            try await self.messageUsecase.mexecute()
            try await self.mexecute_Chat()
        }
        do {
            let result = try await loadMsg.value
            
            log.d(result)
        } catch {
            log.e("error -> \(error.localizedDescription)")
        }
    }
    
    
}
