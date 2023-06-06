//
//  DateExtension.swift
//  GlobalHoneys
//
//  Created by yeoboya-211221-05 on 2023/02/27.
//  Copyright © 2023 GlobalHoneys. All rights reserved.
//

import Foundation

extension Date {
    // 경과 시간 구하기
    public func getElapsedTime() -> ElapsedTime {
        let lastDate = self
        let today = Date()
        let todayMidnight = Calendar.current.startOfDay(for: today)
        let tomorrowStartDate = Calendar.current.date(byAdding: .day, value: 1, to: todayMidnight)!
        
        let lastComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: lastDate)
        let presentComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrowStartDate)
        let dateDifference = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: lastDate, to: tomorrowStartDate)
        
        let defaultReturnValue = String(format: "%02d-%02d-%04d", lastComponent.day!, lastComponent.month!, lastComponent.year!)
        
        // 연도가 다름
        if lastComponent.year != presentComponent.year {
            
            return .detailedDate(date: defaultReturnValue)
            
        } else {
            // 연도가 같음
            switch dateDifference.day! {
            case 3: // 3일 경과
                return .threeDaysAgo
            case 2: // 2일 경과
                return .twoDaysAgo
            case 1: // 1일 경과
                return .yesterday
            case 0: // 오늘
                return .today
            default: return .detailedDate(date: defaultReturnValue)
            }
        }
    }
    
    public enum ElapsedTime: Equatable {
        case today
        case yesterday
        case twoDaysAgo
        case threeDaysAgo
        case detailedDate(date: String)
        
        public var stringValue: String {
            switch self {
            case .today:                  return "Today"
            case .yesterday:              return "Yesterday"
            case .twoDaysAgo:             return "2 days ago"
            case .threeDaysAgo:           return "3 days ago"
            case .detailedDate(let date): return "\(date)"
            }
        }
    }

    public enum Month: Int {
        case jan = 1
        case feb
        case mar
        case apr
        case may
        case jun
        case jul
        case aug
        case sep
        case oct
        case nov
        case dec
        
        public var stringValue: String {
            switch self {
            case .jan: return "Jan"
            case .feb: return "Feb"
            case .mar: return "Mar"
            case .apr: return "Apr"
            case .may: return "May"
            case .jun: return "Jun"
            case .jul: return "Jul"
            case .aug: return "Aug"
            case .sep: return "Sep"
            case .oct: return "Oct"
            case .nov: return "Nov"
            case .dec: return "Dec"
            }
        }
    }
}
