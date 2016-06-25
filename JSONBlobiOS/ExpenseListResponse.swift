//
//  ExpenseListResponse.swift
//  JSONBlobiOS
//
//  Created by ishant on 24/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import ObjectMapper


class ExpenseListResponse: Mappable{
    
    var expenseList:[Expense]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        expenseList <- map["expenses"]
    }
}