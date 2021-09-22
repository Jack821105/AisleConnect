//
//  ChecklistAPIManger.swift
//  AisleConnectDemo
//
//  Created by 許自翔 on 2021/9/14.
//

import Foundation

class ChecklistAPIManger {
    
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func request(callback: @escaping (([BookList])->Void), errorHandler: @escaping ((Error)->Void)) {
        let semaphore = DispatchSemaphore (value: 0)

        let urlString: String = "https://apistage2.aisleconnect.us/ac.server/rest/v2.5/checklist?access_token=\(self.accessToken)"
        
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("JSESSIONID=373885FA68726DF4BD848E9721A6CE81", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            errorHandler(error!)
            semaphore.signal()
            return
          }
            
            let info = try! JSONDecoder().decode(Checklist.self, from: data)
            
            callback(info.data)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
}

