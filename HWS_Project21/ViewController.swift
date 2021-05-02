//
//  ViewController.swift
//  HWS_Project21
//
//  Created by J on 2021/05/02.
//

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))

    }

    
    @objc func registerLocal(){
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        //権限をリクエスト
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            //要求を許可または拒否された時の処理
            if granted {
                print("Permit")
            } else {
                print("Reject")
            }
            
        }
        
    }
    
    @objc func scheduleLocal(){
        
        print("scheduleLocal!!!!")
        
        let center = UNUserNotificationCenter.current()
        
        //保留中（スケジュール済み）の通知を削除
        center.removeAllPendingNotificationRequests()
        
        //何を表示するか
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "body"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        //いつ表示するか
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//      let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //5秒後にロック画面に通知
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerCategories(){
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Title", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userinfo = response.notification.request.content.userInfo
        
        if let customData = userinfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                
            case "show":
                print("Show more infomation")
                
            default:
                break
            }
        }
        
        completionHandler()
        
    }

}

