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
    func openMoreDetailChat()
}

public protocol MessageMediaViewInput {
    func openPhoto()
//    func openCamera()
//    func openVideo()
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
    
    var ptrMember: ChatPartner? { get set }
    
    func getChatListByDate() -> ChatListByDate
    func getChatDate() -> ChatDate
    
    func getSectionToIndex(index: Int) -> String?
    
//    func getSavedChatMessage() -> ChatMessage?
    func getSavedChatMessage() -> ChatUnit?
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
    
    public var ptrMember: ChatPartner?
    
    var chatStore: [ChatUnit] = []
//    var chattings: [ChatMessage] = []
    var chatList: ChatListByDate = [:]
    var sectionList: ChatDate = []
    
    var savedTempMessage: ChatUnit?
    
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
    
    public func getSavedChatMessage() -> ChatUnit? {
        return savedTempMessage
    }
    
    func setChattingData() async {
        do {
            // 전에 읽었던 페이지 있으면 거기에 맞춰서 정렬 해주기
            // 처음이면 대화상대 유저 정보 가져오고, 메세지 로딩
            // 메세지 온 것 있으면 읽음처리
            // 재전송 메세지가 있으면 나중에 맨 밑에 추가해주기
            
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
            try await self.memberUseCase.mexecute_user(reqModel: 20) // usecase
//            try await self.mexecute_User(reqModel: 20) // viewmodel+helper
        }
        
        do {
            
            let ptrInfo = try await ptrInfoTask.value
            ptrMember = ptrInfo ?? ChatPartner(memNo: 0, gender: .none,
                                               memNick: "0", country: "etc", contryCode: "ET",
                                               location: "ETWORLD", photoURL: "", status: .error)
            log.d("== PtrInfo From JSON :: \(ptrInfo) ==")
            
        } catch {
            log.e("error -> \(error.localizedDescription)")
        }
        
    }
    
    func loadMessage(_ type: ScrollType = .bottom) async {
        log.i("[ usecase ] Message : list")
        let loadMsg = Task {
//            try await self.messageUsecase.mexecute_chat() // usecase
            try await self.messageUsecase.fetchMsgs_Mock()
        }
        do {
            let result = try await loadMsg.value
            
            if type == .none {
                chatStore.removeAll()
            }
            
            chatStore.append(contentsOf: result)
            chatStore.sort { $0.msgNo < $1.msgNo }
            
            try groupChatBySection(type)
            
            log.d(result)
        } catch {
            log.e("error -> \(error.localizedDescription)")
        }
    }
    
    func groupChatBySection(_ type: ScrollType = .bottom) throws {
        
        // TODO: 날짜 데이터 -> yyyy-MM-dd 까지만 해서 비교
        let dic = try Dictionary(grouping: self.chatStore, by: { (data) -> String in
            return try data.minsDate.makeLocaleDate()
        })
        
        self.chatList = dic
        self.sectionList = dic.keys.sorted(by: { $0.compare($1) == .orderedAscending })
        
        self._didListLoad.onNext(type)
    }
    
    
}
