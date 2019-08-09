//
//  ViewController.swift
//  GitHubSearch
//
//  Created by huangliru on 2019/8/8.
//  Copyright © 2019年 huangliru. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    // 搜索框
    @IBOutlet weak var searchBar: UISearchBar!
    // 用户搜索列表
    @IBOutlet weak var tableView: UITableView!
    // 列表数据源
    public var listDataArray : Array<Dictionary<String, Any>>? = []
    
    // 分页数据
    public var count : Int?
    public var pages : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewAndDatas()
    }
    
    /// 初始化界面和数据
    func initViewAndDatas() -> Void {
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView .register(UINib.init(nibName: "UserInfoTableViewCell", bundle: Bundle.init(for: UserInfoTableViewCell.classForCoder())), forCellReuseIdentifier: "UserInfoTableViewCell")
        
    }
    
    // MARK: ========UITableViewDelegate========
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.listDataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indentify : String = "UserInfoTableViewCell"
        
        let cell : UserInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: indentify, for: indexPath) as! UserInfoTableViewCell

        if (self.listDataArray![indexPath.row]["language"] == nil) {
            self.searchUserBestLanguageWithUserName(self.listDataArray![indexPath.row]["userName"] as! String , indexPath.row)
        }

        cell.setCellData(self.listDataArray![indexPath.row], indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: ========UISearchBarDelegate========
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            // 获取匹配的用户类表
            self.searUserInfoWithName(searchText)
        }
    }
    
    /// 根据输入的搜索内容查询用户
    ///
    /// - Parameter userName: 用户名
    func searUserInfoWithName(_ userName : String) -> Void {
        
        
        let url : String = "https://api.github.com/search/users?q=" + userName + "&page=1&per_page=10"
        
        APIClient.shareAPIClient.requestJsonData(url, method: .get) { (responseData, error) in
            
            
            if responseData != nil {
                let response = responseData as! [String:Any]
                let userListArray :Array<Dictionary<String, Any>> = (response["items"] as! Array<Dictionary<String, Any>>)

                self.listDataArray?.removeAll()
                for i in 0..<userListArray.count {
                    // 请求的道德用户信息字典
                    let userInfoDict : Dictionary<String,Any> = userListArray[i]
                    // 用来保存列表展示信息的字典
                    var resultDict : Dictionary<String,String> = Dictionary.init()
                    resultDict["headerImageUrl"] = (userInfoDict["avatar_url"] as! String)
                    resultDict["userName"] = (userInfoDict["login"] as! String)
                    
                    self.listDataArray?.append(resultDict)
                }
                
                // 刷新Table View显示
                self.tableView.reloadData()
            }
            else {
                print("查询用户失败")
            }
        }
        
    }
    
    /// 根据用户名查询并统计出该用户使用最多的一种语言
    ///
    /// - Parameter userName: 用户名
    func searchUserBestLanguageWithUserName(_ userName : String, _ index : Int) -> Void {
        
        if (index >= (self.listDataArray?.count)!) {
            return
        }
        let url : String = "https://api.github.com/users/" + userName + "/repos"
        APIClient.shareAPIClient.requestJsonData(url, method: .get) { (responseData, error) in
            
            if responseData != nil {
                let response :Array<Dictionary<String,Any>> = responseData as! Array<Dictionary<String,Any>>
                
                // 遍历请求结果得到用户使用的语言数组
                var languageArray : Array<String> = []
                for i in 0..<response.count {
                    let dict = response[i]
                    
                    let str = dict["language"] as? String
                    
                    if (str != nil){
                        languageArray.append(str!)
                    }else{
                        languageArray.append("")
                    }
                    
                }
                
                // 此处判断是否拿到语言数组且数字长度大于0
                if languageArray.count > 0 {
                    // 遍历语言数组得到出现次数最多的元素
                    var dict : Dictionary<String,Int> = Dictionary.init()
                    for i in 0..<languageArray.count {
                        let str : String = languageArray[i]
                        if dict.index(forKey: str) == nil {
                            dict[str] = 1
                        }else{
                            dict[str] = dict[str]!+1
                        }
                    }
                    
                    
                    // 将字典的key和value分别存放在数组中
                    var allKeys : Array<String> = []
                    var allValues : Array<Int> = []
                    for str in dict.keys {
                        allKeys.append(str)
                        allValues.append(dict[str]!)
                    }
                    // 得到出现次数最多的元素和出现的次数
                    var maxValue : Int = allValues[0]
                    var maxIndex : Int = 0
                    for i in 0..<allValues.count {
                        if allValues[i] > maxValue{
                            maxValue = allValues[i]
                            maxIndex = i;
                        }
                    }
                    print("最常用的语言是:"+allKeys[maxIndex])
                    // 将用户常用语言字段添加到列表展示的数据源中
                    self.listDataArray![index]["language"] = allKeys[maxIndex]
                    
                    // 刷新Table View显示
                    self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.none)

                }else{
                    print("没有最常用的语言")
                    // 将用户常用语言字段添加到列表展示的数据源中
                    self.listDataArray![index]["language"] = ""
                    
                    // 刷新Table View显示
                    self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: UITableViewRowAnimation.none)
                }
                
                            }
            else {
                print("查询用户失败")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

