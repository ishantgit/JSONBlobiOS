//
//  AlamofireUtils.swift
//  JSONBlobiOS
//
//  Created by ishant on 24/06/16.
//  Copyright © 2016 ishant. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class AlamofireUtils {
    
    class func makeUnAuthorisedRequest<T: Mappable>(method: Alamofire.Method, URI : String, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, completionHandler: (T?, String?,Bool) -> Void) {
        if !Utils.isInternetConnected(){
            processFailureResponse("NOINTERNET", completionHandler: completionHandler)
        }
        Alamofire.request(method, URIConstants.BASE_URL + URI, parameters: parameters, encoding: encoding)
            .validate()
            .responseObject(){
                (response: Response<T, NSError>) in
                switch response.result {
                case .Success(let dataObject):
                    processSuccessResponse(dataObject, completionHandler: completionHandler)
                    break
                case .Failure(let error):
                    processFailureResponse(error, completionHandler: completionHandler)
                    break
                }
        }
    }
    
    
    private class func processSuccessResponse<T: Mappable>(response: T, completionHandler: (T?, String?,Bool) -> Void) {
        completionHandler(response, nil,true)
    }
    
    private class func processFailureResponse<T: Mappable>(error: AnyObject, completionHandler: (T?, String?,Bool) -> Void) {
        var errorModel: String?
        if let noInternet = error as? String{
            if noInternet == "NOINTERNET"{
                errorModel = "NOINTERNET"
                completionHandler(nil, errorModel, false)
            }
        }else{
            if error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorNetworkConnectionLost {
                errorModel = "Network Failure"
            } else {
                errorModel = "Something went wrong. Try Again"
            }
            completionHandler(nil, errorModel,true)
        }
    }
    
//    private class func getGenericError() -> ErrorModel {
//        let error = ErrorModel()
//        error.code = 500
//        error.message = "Something went wrong. Try Again"
//        return error
//    }
//    
//    private class func getNetworkFailureError() -> ErrorModel {
//        let error = ErrorModel()
//        error.code = 511
//        error.message = "Network Failure"
//        return error
//    }

}