//
//  APITestViewController.swift
//  TWB_Good_Viewer
//
//  Created by Hank_Zhong on 2018/6/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

enum RequestType:Int {
    case GET = 0,GET_Header,POST_Json,POST_UrlEncoded,POST_FormData,DownloadBlock,DownloadDelegate
}

class APITestViewController: UITableViewController {
    var destinationVC:APITestResultViewController?
    let group = DispatchGroup()
    var progressArr:[(current:Int64,total:Int64)] = []

    let baseGetURL = "https://httpbin.org/get"
    let basePostURL = "https://httpbin.org/post"
    let downLoadURL = "https://farm1.staticflickr.com/801/40228722695_5f1c2e515a_o_d.jpg"
    
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
        self.destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "APITestResultViewController") as? APITestResultViewController
        self.destinationVC?.response = response
        activityIndicator.stopAnimating()
        self.navigationController?.pushViewController(self.destinationVC!, animated: true)
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
            case .DownloadBlock:
                self.showResponse(response: "DownloadBlock")
                API.shared.downloadByDownloadTask(from: downLoadURL, downloadCompletion: { (data) in
                    DispatchQueue.main.async {
                        self.destinationVC?.imageDatas[0] = data
                        self.destinationVC?.setImage()
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                break
            case .DownloadDelegate:
                self.showResponse(response: "DownloadBlock")
                DispatchQueue.main.async {
                    self.destinationVC?.setProgressHidden(setHidden: false)
                }
                let config = URLSessionConfiguration.default
                config.httpMaximumConnectionsPerHost = 3
                API.shared.customizeSessionManager(with: config, delegate: self, delegateQueue: nil)
                group.enter()
                API.shared.downloadByDownloadTask(from: "https://upload.wikimedia.org/wikipedia/commons/7/73/STC_line_1_icon.png")
                group.enter()
                API.shared.downloadByDownloadTask(from: "https://webiconspng.com/wp-content/uploads/2017/09/2-PNG-Image-59527.png")
                group.enter()
                API.shared.downloadByDownloadTask(from: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/3_green.svg/2000px-3_green.svg.png")
                API.shared.customizeSessionManager(delegate: nil)
                self.progressArr = Array(repeating: (0,0), count: API.shared.downloadCount)
                group.notify(queue: DispatchQueue.main) {
                    self.destinationVC?.setImage()
                    self.progressArr.removeAll()
                }
                break
            }
        }
    }
}

extension APITestViewController:URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            return
        }
        print("+++\(downloadTask)")
        self.destinationVC?.imageDatas[downloadTask.taskIdentifier - 1] = data
        group.leave()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.progressArr[downloadTask.taskIdentifier - 1] = (totalBytesWritten,totalBytesExpectedToWrite)
//        let currentProgress = self.currentProgressDict.values.reduce(0, +)
//        let totalProgress = self.totalProgressDict.values.reduce(0, +)
        var rate:Float = 0
        for progress in self.progressArr {
            if progress.total != 0{
                rate += Float(progress.current) / Float(progress.total) / Float(self.progressArr.count)
            }
        }
        DispatchQueue.main.async {
            self.destinationVC?.progressBar.setProgress(rate, animated: true)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("DidResume")
    }
}

