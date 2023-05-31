//
//  JSON+.swift
//  Shared
//
//  Created by root0 on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    func decode<T>(to type: T.Type) -> T? where T: Decodable {
        return try? JSONDecoder().decode(type, from: self.rawData())
    }
}
