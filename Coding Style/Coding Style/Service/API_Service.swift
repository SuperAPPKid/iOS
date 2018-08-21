//
//  APIService.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import Foundation
final class APIService: NSObject {
    static let shared = APIService()
    
    private override init() {
        super.init()
    }
    
    ///取得資料
    func fetchItems(APIName:String, completion: ([Item], Error?)->(Void)) {
        if let path = Bundle.main.path(forResource: APIName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonResult = try JSONDecoder().decode(Response<[Item]>.self, from: data)
                completion(jsonResult.Data,nil)
            } catch {
                completion([], error)
            }
        } else {
            completion([],NSError(domain: "無法取得檔案路徑", code: 9999, userInfo: nil))
        }
    }
}
