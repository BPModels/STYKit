//
//  TYDownloadManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import SDWebImage

public class TYDownloadManager_ty: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    public static let share_ty = TYDownloadManager_ty()
    private let queue_ty = OperationQueue()
    
    /// 防止多个任务进度混淆
    private var progressBlockDic_ty: [String:CGFloatBlock_ty?] = [:]
    private var completeBlockDic_ty: [String:DataBlock_ty?]    = [:]
    
    ///   下载图片（下载完后会同步缓存到项目）
    /// - Parameters:
    ///   - urlStr: 图片网络地址
    ///   - progress: 下载进度
    ///   - completion: 下载后的回调
    public func image_ty( urlStr: String, progress: CGFloatBlock_ty?, completion: ImageBlock_ty?) {
        var urlStrOption: String? = urlStr
        if urlStr.hasChinese_ty() {
            urlStrOption = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        guard let _urlStr = urlStrOption, let url = URL(string: _urlStr) else {
            completion?(nil)
            return
        }
        SDWebImageDownloader.shared.downloadImage(with: url, options: .lowPriority) { receivedSize, expectedSize, url in
            let progressValue = CGFloat(receivedSize)/CGFloat(expectedSize)
            progress?(progressValue)
        } completed: { image, data, error, finished in
            if error != nil {
                print("资源下载失败，地址：\(urlStr), 原因：\(String(describing: error))")
                completion?(nil)
            } else {
                completion?(image)
            }
        }
    }
    
    public func video_ty(name: String, urlStr: String, progress: CGFloatBlock_ty?, completion: DataBlock_ty?) {
        let config  = URLSessionConfiguration.background(withIdentifier: "tenant.cn")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: queue_ty)
        guard let url = URL(string: urlStr) else {
            completion?(nil)
            return
        }
        let task = session.downloadTask(with: URLRequest(url: url)) { url, response, error in
            guard let localUrl = url, let _data = try? Data(contentsOf: localUrl)  else {
                completion?(nil)
                return
            }
            completion?(_data)
            print("下载完成")
        }
        task.resume()
        progressBlockDic_ty["\(task.taskIdentifier)"] = progress
        completeBlockDic_ty["\(task.taskIdentifier)"] = completion
    }
    
    public func audio_ty(name: String, urlStr: String, progress: CGFloatBlock_ty?, completion: DataBlock_ty?) {
        let config  = URLSessionConfiguration.background(withIdentifier: "tenant.cn")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: queue_ty)
        guard let url = URL(string: urlStr) else {
            completion?(nil)
            return
        }
        let task = session.downloadTask(with: URLRequest(url: url)) { url, response, error in
            guard let localUrl = url, let _data = try? Data(contentsOf: localUrl)  else {
                completion?(nil)
                return
            }
            completion?(_data)
            print("下载完成")
        }
        task.resume()
        progressBlockDic_ty["\(task.taskIdentifier)"] = progress
        completeBlockDic_ty["\(task.taskIdentifier)"] = completion
    }
    
    // MARK: ==== URLSessionDelegate ====
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let key = "\(downloadTask.taskIdentifier)"
        guard let block = completeBlockDic_ty[key], let data = try? Data(contentsOf: location) else {
            return
        }
        block?(data)
        completeBlockDic_ty.removeValue(forKey: key)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let key = "\(downloadTask.taskIdentifier)"
        let progress = CGFloat(bytesWritten) / CGFloat(totalBytesWritten)
        guard let block = progressBlockDic_ty[key] else {
            return
        }
        block?(progress)
    }
}
