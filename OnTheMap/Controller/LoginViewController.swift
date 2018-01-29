//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Neel Nishant on 16/01/18.
//  Copyright © 2018 Neel Nishant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.delegate = self
        emailTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromNotification()
    }
    func loginProgress () {
        
        UdacityClient.sharedInstance().taskForPOSTMethod(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
            if success {
                self.completeLogin()
            }
            else {
                
                self.createAlert(title: "Error", message: error!)
            }
        }

    }
    
    func completeLogin () {
        performUIUpdatesOnMain{
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "mapTabBarController") as! UITabBarController
            self.present(controller, animated: true, completion: nil)
            self.activityView.stopAnimating()
        }
       
        
    }
    
    //Alert
    func createAlert(title: String, message: String){
        performUIUpdatesOnMain {
            if self.activityView.isAnimating {
                self.activityView.stopAnimating()
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //TextFieldFunctions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       return true
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
        
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func Login(_ sender: Any) {
        
        if passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            createAlert(title: "Error", message: "Username or password empty")
        }
        else {
            activityView.center = self.view.center
            activityView.startAnimating()
            self.view.addSubview(activityView)
            loginProgress()
            
        }
        
        
    }
    

}

