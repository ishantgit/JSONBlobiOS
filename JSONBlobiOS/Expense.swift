//
//  Expense.swift
//  JSONBlobiOS
//
//  Created by ishant on 24/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper

class Expense : Mappable{
    
    var amount: Double?
    var category: String?
    var id: String?
    var state: String?
    var time: String?
    var description: String?
    
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        amount <- map["amount"]
        category <- map["category"]
        id <- map["id"]
        time <- map["time"]
        description <- map["description"]
        state <- map["state"]
    }
}