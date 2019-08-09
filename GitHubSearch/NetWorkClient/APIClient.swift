//
//  APIClient.swift
//  GitHubSearch
//
//  Created by huangliru on 2019/8/8.
//  Copyright © 2019年 huangliru. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIClient: SessionManager {

    public static let shareAPIClient:APIClient = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.httpAdditionalHeaders = APIClient.defaultHTTPHeaders
        return APIClient(configuration:configuration)
    }()
    
    /// 请求返回json数据
    ///
    /// - Parameters:
    ///   - path: 请求地址
    ///   - method: 请求方法
    ///   - params: 请求参数
    ///   - progressHUD: 是否显示loading
    ///   - handler: 回调处理方法
    public func requestJsonData(_ path:String,method:HTTPMethod,params:[String:Any]? = nil,handler:@escaping (Any?,Error?) -> Void) ->Void {
        var url = path
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("=========请求地址=========\nurl : \(url)")
        if params == nil {
            print("=========请求参数=========\nparams : 暂无")
        }
        else {
            print("=========请求参数=========\nparams : \(params!)")
        }
        switch method {
        case .get:
            self.getRequest(url, params: params, handler: handler)
        case .post:
            self.postRequest(url, params: params, handler: handler, dataHandler: nil)
        default: break
            
        }
        
    }
    
    fileprivate func postRequest(_ url:String,params:[String:Any]? = nil,handler:((Any? ,Error?) -> Void)?,dataHandler:((Any? , Error?) -> Void)?) -> Void {
        let headers:HTTPHeaders = APIClient.defaultHTTPHeaders
        print(headers)
        
        self.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (responseData) in
            
            switch responseData.result {
            case .success(let value):
                print(value)
                if handler != nil {
                    handler!(value,nil)
                }
                
            case .failure(let error):
                print(error)
                if handler != nil {
                    handler!(nil,error)
                }
            }
            }.responseData { (data) in
                switch data.result {
                case .success(let value):
                    if dataHandler != nil {
                        dataHandler!(value,nil)
                    }
                case .failure(let error):
                    if dataHandler != nil {
                        dataHandler!(nil,error)
                    }
                }
        }
        
    }
    
    fileprivate func getRequest(_ url:String,params:[String:Any]? = nil,handler:@escaping (Any?,Error?) -> Void) -> Void {
        
         let headers:HTTPHeaders = APIClient.defaultHTTPHeaders
        
        self.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                handler(value,nil)
            case .failure(let error):
                print(error)
                handler(nil,error)
            }
        }
    }
}
