//
//  CommonUtils.swift
//  whotIOS
//
//  Created by Sapido on 2018/1/23.
//  Copyright © 2018年 Whot inc. All rights reserved.

import Foundation
import Toast_Swift
import TTGSnackbar

class CommonUtils {
    
    /**
     * show Toast
     * @param message [message] String
     */
    static func showToast(view : UIView,message : String) {
        // create a new style
        var style = ToastStyle()
        // this is just one of many style options
        style.messageColor = .white
        // present the toast with the new style
        //        self.view.makeToast("This is a piece of toast", duration: 3.0, position: .bottom, style: style)
        // or perhaps you want to use this style for all toasts going forward?
        // just set the shared style and there's no need to provide the style again
        ToastManager.shared.style = style
        view.makeToast(message) // now uses the shared style
        // toggle "tap to dismiss" functionality
        ToastManager.shared.isTapToDismissEnabled = true
        // dismiss current toast and all queued toasts
        view.hideToastActivity()
        // toggle queueing behavior
        ToastManager.shared.isQueueEnabled = true
    }
    
    /**
     * show alert
     * @param message [message] String
     */
    static func showAlert(message : String , doPrev: Bool ,  handler: @escaping () -> ()){
        var alertController = UIAlertController()
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }
        //dismiss all alert
        //        viewController.dismiss(animated: true, completion: nil)
        // 建立一個提示框
        alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            //prev page
            if doPrev{
                handler()
            }
        })
        alertController.addAction(okAction)
        // 顯示提示框
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showSnackBar(message: String){
        let snackbar = TTGSnackbar(message: message, duration: .middle)
        snackbar.show()
    }
    
    /*
     * show alert with multiple button
     * @param title [alert title]
     * @param message [alert message]
     * @param setTextField [add text field]
     * @param setCancel [cancel button]
     */
    
    static func showAlertWithMultipleButton(alertController : UIAlertController , setCancel:Bool, handler: @escaping (String) -> ()){
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }
        //dismiss alert
        alertController.dismiss(animated: true, completion: nil)
        
        //check if you need cancel button
        if(setCancel){
            //set cancel
            alertController.addAction(UIAlertAction(title: "取消", style: .cancel,  handler: {   (action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        
        //clicks OK.
        alertController.addAction(UIAlertAction(title: "內設定", style: .default, handler: {   (action: UIAlertAction!) -> Void in
            handler("0")
        }))
        
        //clicks OK.
        alertController.addAction(UIAlertAction(title: "外設定", style: .default, handler: {   (action: UIAlertAction!) -> Void in
            handler("1")
        }))
        
        // 4. Present the alert.
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    /*
     * show alert with text field
     * @param title [alert title]
     * @param message [alert message]
     * @param setTextField [add text field]
     * @param setCancel [cancel button]
     */
    
    static func showAlertWithEvent(alertController : UIAlertController , setTextField:Bool , setCancel:Bool, handler: @escaping () -> ()){
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }
        //dismiss alert
        alertController.dismiss(animated: true, completion: nil)
        //check if you need a TextField then add it. You can configure it however you need.
        if(setTextField){
            alertController.addTextField { (textField) in
                //set text type is pwd
                textField.isSecureTextEntry = false
            }
        }
        //check if you need cancel button
        if(setCancel){
            //set cancel
            alertController.addAction(UIAlertAction(title: "取消", style: .cancel,  handler: {   (action: UIAlertAction!) -> Void in
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        
        //clicks OK.
        alertController.addAction(UIAlertAction(title: "確認", style: .default, handler: {   (action: UIAlertAction!) -> Void in
            handler()
        }))
        
        // 4. Present the alert.
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //檢查欄位
    static func checkTextFieldIsBlank(sender : UITextField!,view : UIView ,message : String!) -> Bool{
        if sender.text == "" {
            //提醒視窗
            self.showToast(view: view, message: message)
            //            self.showAlert(message: message, doPrev: false)
            return true
        }
        return false
    }
    
    /**
     * get bitmap from view
     */
    static func imageWithView(view: UIView) -> UIImage {
        //save image with view
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        //draw
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    /**
     * next page no parameter
     */
    static func nextView(name : String , controller : String) -> UIViewController{
        return UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: controller) as UIViewController
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 255, height: 30))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 255, height: 30))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
