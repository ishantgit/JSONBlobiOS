//
//  StateType.swift
//  JSONBlobiOS
//
//  Created by ishant on 25/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation

enum StateType:String {
    
    case VERIFIED , UNVERIFIED, FRAUDUANT
    
    static func getStateType(type: String) -> StateType{
        switch type {
        case VERIFIED.rawValue:
            return .VERIFIED
        case UNVERIFIED.rawValue:
            return .UNVERIFIED
        default:
            return .FRAUDUANT
        }
    }
}