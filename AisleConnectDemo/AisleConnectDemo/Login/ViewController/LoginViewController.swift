//
//  LoginViewController.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/4.
//

import UIKit

// MARK: - StoryboardInstantiable

extension LoginViewController: StoryboardInstantiable {}

/// 登入頁
class LoginViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    /// 帳號
    @IBOutlet weak var accountTextField: UITextField!
    
    /// 密碼
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var blueViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Prototype
    
    var moveHeight: CGFloat?
    
    var textFieldTargetY: CGFloat?
    
    var keyboardShowStatus: Bool = false
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        setupTextField()
        
    }
    
    // MARK: - Method
    
    private func setupTextField() {
        accountTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector (keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func showWarningWindow(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let keyboardY = self.view.bounds.size.height - keyboardSize.height
            
            if keyboardShowStatus == true {
                return
            }
            
            keyboardShowStatus = true
            
            if let textFieldTargetY = textFieldTargetY {
                if textFieldTargetY > keyboardY {
                    moveHeight = textFieldTargetY - keyboardY
                    blueViewBottomConstraint.constant += moveHeight ?? 0
                }
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        blueViewBottomConstraint.constant -= moveHeight ?? 0
        keyboardShowStatus = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: - IBAction

extension LoginViewController {
    
    @IBAction func willLogin(_ sender: Any) {
        
        guard let userName = accountTextField.text, let password = passwordTextField.text else {
            return
        }
        
        guard userName.isEmpty == false || password.isEmpty == false else {
            showWarningWindow(title: "error", message: "忘記輸入帳號或密碼~~")
            return
        }
        
        let userInfo: LoginInfo = LoginInfo(username: userName, password: password)
        
        LoginAPI.shared.login(loginInfo: userInfo) { (info) in
                let vc = ChecklistViewController.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
        } errorHandler: {
            self.showWarningWindow(title: "error", message: "輸入帳號或密碼有誤～～")
        }

        
    }
}



// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    
    // 當按下右下角的return鍵時觸發
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 關閉鍵盤
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldRect = textField.convert(textField.bounds, to:self.view)
        textFieldTargetY = textFieldRect.origin.y + textFieldRect.size.height
    }
    
}
