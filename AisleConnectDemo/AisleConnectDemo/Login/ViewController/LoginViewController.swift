//
//  LoginViewController.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/4.
//

import UIKit
import SDWebImage
import Alamofire

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
        
//        AF.request(URL(string: "https://apistage2.aisleconnect.us/ac.server/oauth/token")!, method: .post, parameters: LoginRequset(username: "paul.lin@lineagenetworks.com", password: "welcome1"), encoder: , headers: nil, interceptor: nil, requestModifier: nil)
//        AF.request(<#T##convertible: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Encodable?#>, encoder: <#T##ParameterEncoder#>, headers: <#T##HTTPHeaders?#>, interceptor: RequestInterceptor?, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
        
        
//        AF.request("https://apistage2.aisleconnect.us/ac.server/oauth/token", method: .post, parameters: LoginRequset(username: "paul.lin@lineagenetworks.com", password: "welcome1"), encoding: ParameterEncoding(), headers: nil, interceptor: nil, requestModifier: nil)
//        AF.request("https://apistage2.aisleconnect.us/ac.server/oauth/token",
//                   method: .post,
//                   parameters: "grant_type=password&username=paul.lin@lineagenetworks.com&password=welcome1&client_id=my-client&client_secret=my-secret&scope=read",
//                   encoder: JSONParameterEncoder.default).response { response in
//                    debugPrint(String(data: response.data!, encoding: .utf8))
//        }
        
//        AF.request("https://apistage2.aisleconnect.us/ac.server/oauth/token", method: .post, parameters: "grant_type=password&username=paul.lin@lineagenetworks.com&password=welcome1&client_id=my-client&client_secret=my-secret&scope=read", encoding: <#T##ParameterEncoding#>, headers: .init(["application/x-www-form-urlencoded": "Content-Type"]), interceptor: <#T##RequestInterceptor?#>, requestModifier: <#T##Session.RequestModifier?##Session.RequestModifier?##(inout URLRequest) throws -> Void#>)
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "grant_type=password&username=paul.lin%40lineagenetworks.com&password=welcome1&client_id=my-client&client_secret=my-secret&scope=read"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://apistage2.aisleconnect.us/ac.server/oauth/token")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("JSESSIONID=87DF0C2A3216A7CB07ED4FAAD72B4BFE", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
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
