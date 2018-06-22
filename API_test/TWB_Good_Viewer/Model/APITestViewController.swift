//
//  APITestViewController.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

enum RequestType:Int {
    case GET = 0,GET_Header,POST_Json,POST_UrlEncoded,POST_FormData,Download
}

class APITestViewController: UITableViewController {

    let baseGetURL = "https://httpbin.org/get"
    let basePostURL = "https://httpbin.org/post"
    
    let getParameters = ["para1":"value1","para2":"value2"]
    let getHeaders = ["header1":"value1","header2":"value2"]
    let postJSON = ["para1":"value1","para2":"value2"]
    let postURLencoded = "para1=value1&para2%5Bvalue21%5D=value22"
    let postFormData = ["para1":"value1"]
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    func showResponse(response:String) {
        guard let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "APITestResultViewController") as? APITestResultViewController else { return }
        destinationVC.response = response
        activityIndicator.stopAnimating()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        API.shared.cancelAllTask()
        tableView.deselectRow(at: indexPath, animated: false)
        activityIndicator.startAnimating()
        if indexPath.section == 0 {
            guard let requestType = RequestType(rawValue: indexPath.row) else { return }
            switch requestType {
            case .GET:
                API.shared.requestWithURL(urlString: baseGetURL, parameters: getParameters, completion: { (data) in
                    guard let response:NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? NSDictionary else { return }
                    DispatchQueue.main.async {
                        self.showResponse(response: response.description )
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                break
            case .GET_Header:
                API.shared.requestWithHeader(urlString: baseGetURL, parameters: getHeaders, completion: { (data) in
                guard let response:NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? NSDictionary else { return }
                DispatchQueue.main.async {
                    self.showResponse(response: response.description )
                }
            }) { (error) in
                print(error.localizedDescription)
            }
                break
            case .POST_Json:
                API.shared.requestWithJSONBody(urlString: basePostURL, parameters: postJSON, completion: { (data) in
                    guard let response:NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? NSDictionary else { return }
                    DispatchQueue.main.async {
                        self.showResponse(response: response.description )
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                break
            case .POST_UrlEncoded:
                API.shared.requestWithUrlencodedBody(urlString: basePostURL, parameters: postURLencoded, completion: { (data) in
                    guard let response:NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? NSDictionary else { return }
                    DispatchQueue.main.async {
                        self.showResponse(response: response.description )
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                break
            case .POST_FormData:
                let dataPath:[String : Data] = ["file":UIImageJPEGRepresentation(UIImage(named: "1")!, 0.5)!]
                API.shared.requestWithFormData(urlString: basePostURL, parameters: postFormData, dataPath: dataPath, completion: { (data) in
                    guard let response:NSDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? NSDictionary else { return }
                    DispatchQueue.main.async {
                        self.showResponse(response: response.description )
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            case .Download:
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForResource = .infinity
                API.shared.customizeSessionManager(with: config, delegate: self, delegateQueue: nil)
                break
            }
        }
    }
}

extension APITestViewController:URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {}
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
}

