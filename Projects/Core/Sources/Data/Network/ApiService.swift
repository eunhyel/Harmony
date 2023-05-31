import Alamofire
import Foundation
import SwiftyJSON
import Moya

public typealias APIParameter = [String : Any]

open class ApiService{
    
    public init(){}
    
    public static func responseData(request with : URLRequest) async throws -> Data {
        let response = await AF.request(with).serializingData().response
        
        if response.response?.statusCode != 200 {        }
        return try response.result.get()
    }
}


struct CustomResponseModel: Codable {
    var code: String
    var description: String
    var result: JSON
}
