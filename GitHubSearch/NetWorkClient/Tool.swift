//
//  Tool.swift
//  GitHubSearch
//
//  Created by huangliru on 2019/8/8.
//  Copyright © 2019年 huangliru. All rights reserved.
//

import UIKit

open class Tool: NSObject {

    public var JSONString : String {
        var json = ""
        let data = try?JSONSerialization.data(withJSONObject: self as Any, options: [])
        
        if data == nil {
            print("=========解析失败=========")
            return json
        }
        else {
            json = String.init(data: data!, encoding: .utf8)!
        }
        return json
    }
}
