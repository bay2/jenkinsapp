//
//  LoginViewController.swift
//  JenkinsApp
//
//  Created by xuemincai on 16/1/2.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SCLAlertView
import Log
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var serverLab: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var serverView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var serverTableViewTopLine: UIView!
    @IBOutlet weak var serverTableView: UITableView!
    @IBOutlet weak var addServerView: UIView!
    
    var isExpand = false
    
    let serverInfos = try! Realm().objects(ServerData)
    let realm = try! Realm()
    
    var notificationToken : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.setBackgroundColor(UIColor(hex: 0x3890FD), forState: .Normal)
        loginBtn.setBackgroundColor(UIColor(hex: 0x2779db), forState: .Highlighted)
        
        serverTableView.tableFooterView = UIView()
        serverTableView.tableHeaderView = UIView()
        
        notificationToken = realm.addNotificationBlock({ (notification, realm) -> Void in
            self.serverTableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     点击展开服务器菜单
     
     - parameter sender:
     */
    @IBAction func onClickList(sender: UIButton) {
        
        expandServerList()
        
    }
    
    /**
     展开服务器列表
     */
    func expandServerList() {
        
        self.isExpand = !self.isExpand
        
        self.addServerView.hidden = true
        
        self.view.setNeedsUpdateConstraints()
        self.view.updateConstraintsIfNeeded()
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            if self.isExpand == true {
                self.addServerView.hidden = false
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if isExpand {
            
            
            serverTableViewTopLine.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(0.5)
            })
            
            serverTableView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(150)
                
            })
            
            userView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(userView.size.height + 190)
            })
            
            
        } else {
            
            userView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(121)
            })
            
            serverTableView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(0)
            })
            
            serverTableViewTopLine.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(0)
            })
            
        }
    }

    /**
     添加服务器
     
     - parameter sender:
     */
    @IBAction func onClickAddServer(sender: UIButton) {
        
        var alert = SCLAlertView()
        
        let serverName = alert.addTextField("服务器名")
        let serverAddr = alert.addTextField("服务器地址")
        
        alert.addButton("Add") { () -> Void in
            Log.info("服务器名：\(serverName.text)  服务器地址：\(serverAddr.text)")
            
            let serverInfo = ServerData()
            serverInfo.serverName = serverName.text!
            serverInfo.serverAddr = serverAddr.text!
            
            if (serverName.text?.isEmpty == true || serverAddr.text?.isEmpty == true) {
                alert = SCLAlertView()
                alert.showError("添加失败", subTitle: "服务器名或服务器地址为空")
                return
            }
            
            let retServers = self.realm.objects(ServerData).filter("serverName == '\(serverName.text!)'")
            
            if retServers.isEmpty == false {
                alert = SCLAlertView()
                alert.showError("添加失败", subTitle: "服务器名已存在")
                return
            }
            
            self.realm.beginWrite()
            self.realm.add(serverInfo)
            try! self.realm.commitWrite()
            
        }
        
        alert.showEdit("添加服务器", subTitle: "请输入你的服务器信息")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
