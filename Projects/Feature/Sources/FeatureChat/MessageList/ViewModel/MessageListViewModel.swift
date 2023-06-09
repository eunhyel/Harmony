//
//  MessageListViewModel.swift
//  Feature
//
//  Created by root0 on 2023/06/01.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

import Core
import Shared

public struct MessageListActions {
    var openMessageView: (() async -> Void)?
    var openProfileView: (() -> Void)?
}

public protocol MessageListViewModelInput {
    func viewDidLoad()
    func didOpenMessageView(index: IndexPath) async
    func didSwipeDelete()
}
public protocol MessageListViewModelOutput {
    var _isEditing: BehaviorRelay<Bool> { get set }
    var _memberStatusPopup: PublishSubject<(memberStatus: MemberStatus, shortMessage: String)> { get set }
    var _listDidLoad: PublishSubject<Bool> { get set }
}

public protocol MessageListViewModel: MessageListViewModelInput, MessageListViewModelOutput {
    var messageList: [String] { get set }
    var messageDic: [String: [String]] { get set }
    var sectionKeyList: [String] { get set }
    func loadMessageBoxList()
    func receiveNewMessage(data: JSON)
    func lastMessageDelete(memNo: Int, msgNo: Int)
    func getSectionElapsedDateToIndex(index: Int) -> Date.ElapsedTime?
}

public class DefaultMessageListViewModel: MessageListViewModel {
    
    var actions: MessageListActions?
    
//    var messageUseCase: FetchMessageUseCase
//    var memberUseCase: FetchMemberUseCase
    
    public var messageList: [String] = Dummy.content
    
    public var messageDic: [String : [String]] = [:]
    public var sectionKeyList: [String] = []
    
    
    public init(actions: MessageListActions? = nil) {
        self.actions = actions
    }
    
    // MARK: - OUTPUT
    public var _isEditing: RxRelay.BehaviorRelay<Bool> = .init(value: false)
    
    public var _memberStatusPopup: RxSwift.PublishSubject<(memberStatus: MemberStatus, shortMessage: String)> = .init()
    
    public var _listDidLoad: RxSwift.PublishSubject<Bool> = .init()
    
    
    
    deinit {
        log.d("deinit")
    }
}

extension DefaultMessageListViewModel {
    
    public func loadMessageBoxList() {
        
    }
    
    public func receiveNewMessage(data: SwiftyJSON.JSON) {
        
    }
    
    public func lastMessageDelete(memNo: Int, msgNo: Int) {
        
    }
    
    public func getSectionElapsedDateToIndex(index: Int) -> Date.ElapsedTime? {
        return .today
    }
    
}

extension DefaultMessageListViewModel {
    
    public func viewDidLoad() {
        
    }
    
    public func didOpenMessageView(index: IndexPath) async {
        log.i("[ UseCase ] Member : ")
        log.i("[ UseCase ] Message : ")
        
        do {
            Task {
                await self.actions?.openMessageView?()
            }
        } catch {
            
        }
    }
    
    public func didSwipeDelete() {
        log.i("[ usecase ] Message : delete list")
        
        Task {
            
        }
    }
    
}
