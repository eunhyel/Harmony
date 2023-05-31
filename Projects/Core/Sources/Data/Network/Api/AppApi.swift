import Foundation
import Moya
import Shared

enum AppAPI {
    case chatBot(APIParameter)
}

extension AppAPI: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .chatBot: return URL(string: App.startPage)!
            
        }
    }

    public var path: String {
        switch self {
        case .chatBot: return "/_global/api/index.php"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .chatBot: return .post
            
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .chatBot(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
        
    public var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "User-Agent": UserDefaultsManager.userAgent ?? ""]
    }
        
    public var validationType: ValidationType {
        return .successCodes
    }
}
