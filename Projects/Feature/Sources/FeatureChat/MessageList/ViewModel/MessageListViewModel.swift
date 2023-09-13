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
    var _listDidLoad: PublishRelay<Bool> { get set }
}

public protocol MessageListViewModel: MessageListViewModelInput, MessageListViewModelOutput {
    typealias BoxUnit = BoxList
    typealias BoxDic = [String : [BoxList]]
    typealias BoxSectionKeys = [String]
    
    var messageList: [BoxUnit] { get set }
    var messageDic: BoxDic { get set }
    var sectionKeyList: BoxSectionKeys { get set }
    func loadMessageBoxList(isPaging: Bool)
    func receiveNewMessage(data: JSON)
    func lastMessageDelete(memNo: Int, msgNo: Int)
    func getSectionElapsedDateToIndex(index: Int) -> Date.ElapsedTime?
}

public class DefaultMessageListViewModel: MessageListViewModel {
    
    var actions: MessageListActions?
    
    var messageUseCase: FetchMessageUseCase
    var memberUseCase: FetchMemberUseCase
    
    // MARK: 메세지함 리스트
    public var messageLists: [String] = Dummy.content
    public var messageList: [BoxUnit] = []
    // MARK: 날짜 별 섹션 딕셔너리 & Key 배열
    public var messageDic: BoxDic = [:]
    public var sectionKeyList: BoxSectionKeys = []
    
    
    public init(actions: MessageListActions? = nil, messageUseCase: FetchMessageUseCase, memberUseCase: FetchMemberUseCase) {
        self.actions = actions
        
        self.messageUseCase = messageUseCase
        self.memberUseCase = memberUseCase
    }
    
    // MARK: - OUTPUT
    public var _isEditing: RxRelay.BehaviorRelay<Bool> = .init(value: false)
    
    public var _memberStatusPopup: RxSwift.PublishSubject<(memberStatus: MemberStatus, shortMessage: String)> = .init()
    
    public var _listDidLoad: PublishRelay<Bool> = .init()
    
    
    
    deinit {
        log.d("deinit")
    }
}

extension DefaultMessageListViewModel {
    
    public func loadMessageBoxList(isPaging: Bool = false) {
        Task {
            
            do {
                let fetchedList = try await messageUseCase.fetchMsgBoxList_Mock()
                
                messageList = fetchedList
                
                //try checkLastMessageOfDate()
                groupMsgBoxBySection()
                
                _listDidLoad.accept(false)
                
            } catch {
                log.e("error -> \(error.localizedDescription)")
            }
        }
    }
    
    func groupMsgBoxBySection() {
    
        let dic = try Dictionary(grouping: self.messageList, by: { $0.lastTime })
        
        messageDic = dic
        sectionKeyList = dic.keys.sorted(by: { $0.toDateWithReverse().compare($1.toDateWithReverse()) == .orderedDescending })
        
    }
    
    public func getSectionElapsedDateToIndex(index: Int) -> Date.ElapsedTime? {
        return .today
    }
    
}

extension DefaultMessageListViewModel {
    
    public func viewDidLoad() {
        loadMessageBoxList()
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

extension DefaultMessageListViewModel {
    // MARK: - 소켓 처리
    public func receiveNewMessage(data: SwiftyJSON.JSON) {
        
    }
    
    public func lastMessageDelete(memNo: Int, msgNo: Int) {
        
    }
    
}
