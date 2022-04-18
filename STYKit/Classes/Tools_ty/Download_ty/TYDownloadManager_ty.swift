//
//  TYDownloadManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import SDWebImage

/// 下载管理器
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
    public func image_ty( urlStr_ty: String, progress_ty: CGFloatBlock_ty?, completion_ty: ImageBlock_ty?) {
        var urlStrOption_ty: String? = urlStr_ty
        if urlStr_ty.hasChinese_ty() {
            urlStrOption_ty = urlStr_ty.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        guard let _urlStr_ty = urlStrOption_ty, let url_ty = URL(string: _urlStr_ty) else {
            completion_ty?(nil)
            return
        }
        SDWebImageDownloader.shared.downloadImage(with: url_ty, options: .lowPriority) { receivedSize_ty, expectedSize_ty, url_ty in
            let progressValue_ty = CGFloat(receivedSize_ty)/CGFloat(expectedSize_ty)
            progress_ty?(progressValue_ty)
        } completed: { image_ty, data_ty, error_ty, finished_ty in
            if error_ty != nil {
                print("资源下载失败，地址：\(urlStr_ty), 原因：\(String(describing: error_ty))")
                completion_ty?(nil)
            } else {
                completion_ty?(image_ty)
            }
        }
    }
    
    public func video_ty(name_ty: String, urlStr_ty: String, progress_ty: CGFloatBlock_ty?, completion_ty: DataBlock_ty?) {
        let config_ty  = URLSessionConfiguration.background(withIdentifier: "tenant_ty.cn")
        let session_ty = URLSession(configuration: config_ty, delegate: self, delegateQueue: queue_ty)
        guard let url_ty = URL(string: urlStr_ty) else {
            completion_ty?(nil)
            return
        }
        let task_ty = session_ty.downloadTask(with: URLRequest(url: url_ty)) { url_ty, response_ty, error_ty in
            guard let localUrl_ty = url_ty, let _data_ty = try? Data(contentsOf: localUrl_ty)  else {
                completion_ty?(nil)
                return
            }
            completion_ty?(_data_ty)
            print("下载完成_ty")
        }
        task_ty.resume()
        progressBlockDic_ty["\(task_ty.taskIdentifier)"] = progress_ty
        completeBlockDic_ty["\(task_ty.taskIdentifier)"] = completion_ty
    }
    
    public func audio_ty(name_ty: String, urlStr_ty: String, progress_ty: CGFloatBlock_ty?, completion_ty: DataBlock_ty?) {
        let config_ty  = URLSessionConfiguration.background(withIdentifier: "tenant_ty.cn")
        let session_ty = URLSession(configuration: config_ty, delegate: self, delegateQueue: queue_ty)
        guard let url_ty = URL(string: urlStr_ty) else {
            completion_ty?(nil)
            return
        }
        let task_ty = session_ty.downloadTask(with: URLRequest(url: url_ty)) { url_ty, response_ty, error_ty in
            guard let localUrl_ty = url_ty, let _data_ty = try? Data(contentsOf: localUrl_ty)  else {
                completion_ty?(nil)
                return
            }
            completion_ty?(_data_ty)
            print("下载完成_ty")
        }
        task_ty.resume()
        progressBlockDic_ty["\(task_ty.taskIdentifier)"] = progress_ty
        completeBlockDic_ty["\(task_ty.taskIdentifier)"] = completion_ty
    }
    
    // MARK: ==== URLSessionDelegate ====
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let key_ty = "\(downloadTask.taskIdentifier)"
        guard let block_ty = completeBlockDic_ty[key_ty], let data_ty = try? Data(contentsOf: location) else {
            return
        }
        block_ty?(data_ty)
        completeBlockDic_ty.removeValue(forKey: key_ty)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let key_ty = "\(downloadTask.taskIdentifier)"
        let progress_ty = CGFloat(bytesWritten) / CGFloat(totalBytesWritten)
        guard let block_ty = progressBlockDic_ty[key_ty] else {
            return
        }
        block_ty?(progress_ty)
    }
}
