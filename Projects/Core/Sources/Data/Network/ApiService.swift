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
    
    public static func parseData_MockJSON(resource name: String) async throws -> Data? {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            return nil
        }
        
        guard let jsonString = try? String(contentsOfFile: path) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        let data = jsonString.data(using: .utf8)
        
        return data
    }
}


struct CustomResponseModel: Codable {
    var code: String
    var description: String
    var result: JSON
}
