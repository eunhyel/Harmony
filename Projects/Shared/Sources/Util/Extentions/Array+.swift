//
//  Array+.swift
//  Shared
//
//  Created by root0 on 2023/05/31.
//  Copyright © 2023 Harmony. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
