//
//  FilterSearchModel.swift
//  GlobalYeoboya
//
//  Created by inforex_imac on 2023/01/19.
//  Copyright © 2023 GlobalYeoboya. All rights reserved.
//

import Foundation


struct FilterSearchModel{
    
    
    
    var searchMarriageType : String?
    var searchGender       : String?
    var searchMinAge       : String?
    var searchMaxAge       : String?
    
    internal init(searchMarriageType: String? = nil, searchGender: String? = nil, searchMinAge: String? = nil, searchMaxAge: String? = nil) {
        self.searchMarriageType = searchMarriageType
        self.searchGender = searchGender
        self.searchMinAge = searchMinAge
        self.searchMaxAge = searchMaxAge
    }
    
}
