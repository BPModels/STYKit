//
//  TYRequestManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

/// 网络请求回调协议
public protocol TYNetworkDelegate_ty: NSObjectProtocol {
    /// 处理状态码（如果返回true，则不调用success或fail回调）
    /// - Parameter code: 状态吗
    /// - Returns: 是否已处理
    func handleStatusCode_ty(code: Int) -> Bool
    /// 处理错误内容（如果返回true，则不调用success或fail回调）
    /// - Parameter message: 错误内容
    /// - Returns: 是否已处理
    func handleErrorMessage_ty(message: String) -> Bool
    /// 无网络
    func noNetwork_ty()
    /// 无网络权限
    func noAuthNetwork_ty()
}

public struct TYNetworkManager_ty {
    
    public static var share_ty = TYNetworkManager_ty()
    
    public weak var delegate_ty: TYNetworkDelegate_ty?
    
    // MARK: ==== Request ====
    /// 普通HTTP Request, 支持GET、POST、PUT等方式
    /// - Parameters:
    ///   - type: 定义泛型对象类型
    ///   - request: 继承TYRequest_ty的请求对象
    ///   - success: 成功回调的闭包
    ///   - fail: 失败回调的闭包
    /// - Returns: 返回请求体，支持取消请求
    @discardableResult
    public func request_ty <T> (_ type: T.Type, request: TYRequest_ty, success: ((_ response: T?) -> Void)?, fail: ((_ responseError: NSError?) -> Void)?) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 检测网络
        guard checkNetwork_ty() else {
            fail?(nil)
            return nil
        }
        switch request.method_ty {
        case .post_ty:
            // 发起请求，并返回请求体
            return self.httpPostRequest_ty(type, request: request) { (response) in
                // 处理Code
                self.handleStatusCode_ty(response, request: request, success: success, fail: fail)
            }
        case .get_ty:
            return self.httpGetRequest_ty(type, request: request) { (response) in
                self.handleStatusCode_ty(response, request: request, success: success, fail: fail)
            }
        case .put_ty:
            return self.httpPutRequest_ty(type, request: request) { (response) in
                self.handleStatusCode_ty(response, request: request, success: success, fail: fail)
            }
        default:
            fail?(nil)
            return nil
        }
    }
  
    // TODO: ---- POST ----
    @discardableResult
    private func httpPostRequest_ty <T> (_ type: T.Type, request: TYRequest_ty, handle:@escaping (_ response: DataResponse <T, AFError>?) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url = request.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters = requestParametersReduceValueNil_ty(request.parameters_ty)
        // 添加Header
        var _request = URLRequest(url: url)
        _request.httpMethod          = request.method_ty.rawValue
        _request.allHTTPHeaderFields = request.header_ty
        // 是否加密
        _request.allHTTPHeaderFields?["_security_"] = request.isEncrypt ? "1" : "0"
        do {
            // 添加参数
            if let _parameters = parameters {
                try _request.httpBody = JSONSerialization.data(withJSONObject: _parameters, options: [])
            }
            // 发起请求
            let request = AF.request(_request).responseObject { (response: DataResponse<T, AFError>) in
                handle(response)
            }
            
            // 返回请求体
            let taskRequest: TYTaskRequestDelegate_ty = TYRequestModel_ty(request: request)
            return taskRequest
        } catch let error {
            print("Post request error: \(error)  (_ty)")
            handle(nil)
            return nil
        }
    }
    
    // TODO: ---- GET ----
    @discardableResult
    private func httpGetRequest_ty <T>(_ type: T.Type, request: TYRequest_ty, handle:@escaping (_ response: DataResponse <T, AFError>?) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url = request.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters = requestParametersReduceValueNil_ty(request.parameters_ty)
        // 发起请求
        let task = AF.request(url, method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders(request.header_ty)).responseObject { (response: DataResponse <T, AFError>) in
            handle(response)
        }
        let taskRequest: TYTaskRequestDelegate_ty = TYRequestModel_ty(request: task)
        return taskRequest
    }
    
    // TODO: ---- PUT ----
    @discardableResult
    private func httpPutRequest_ty <T>(_ type: T.Type, request: TYRequest_ty, handle:@escaping (_ response: DataResponse <T, AFError>) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url = request.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters = requestParametersReduceValueNil_ty(request.parameters_ty)
        // 发起请求
        let task = AF.request(url, method: HTTPMethod.put, parameters: parameters, encoding: URLEncoding.default, headers: HTTPHeaders(request.header_ty)).responseObject { (response: DataResponse <T, AFError>) in
            handle(response)
        }
        let taskRequest: TYTaskRequestDelegate_ty = TYRequestModel_ty(request: task)
        return taskRequest
    }
    
    // MARK: ==== UPLOAD ====
//    /// 上传文件，支持多个文件（参数附件必须是BPFileModel类型，Key是“uploadFileKey”，或者用常量kUploadFilesKey）
//    /// - Parameters:
//    ///   - type: 对象类型
//    ///   - request: 请求体
//    ///   - uploadProgress: 上传进度回调
//    ///   - success: 成功回调
//    ///   - fail: 失败回调
//    /// - Returns: 返回请求体，支持取消请求
//    @discardableResult
//    public func httpUploadRequestTask_ty <T> (_ type: T.Type, request: TYRequest_ty, uploadProgress: ((Progress) -> Void)?, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
//        // 校验url
//        guard let url = request.url_ty else {
//            return nil
//        }
//        // 校验参数（移除Value为空的参数）
//        let parameters = self.requestParametersReduceValueNil_ty(request.parameters_ty)
//        // 添加Header
//        var header = request.header_ty
//        header["Content-Type"] = "multipart/form-data"
//        // 发起请求
//        let task = AF.upload(multipartFormData: { multipartFormData in
//            guard let model = parameters?[kUploadFilesKey] as? NSString else {
//                return
//            }
//            // 批量上传的文件
//            model.files.forEach { dataTuple in
//                let name = dataTuple.0
//                let data = dataTuple.1
//                multipartFormData.append(data, withName: "file", fileName: name, mimeType: "application/octet-stream; charset=utf-8")
//            }
//            /// 单个上传的文件
//            if let dataTuple = model.file_ty {
//                let name = dataTuple.0
//                let data = dataTuple.1
//                multipartFormData.append(data, withName: "file", fileName: name, mimeType: "application/octet-stream; charset=utf-8")
//            }
//        }, to: url, usingThreshold: UInt64(), method: HTTPMethod(rawValue: request.method_ty.rawValue) , headers: HTTPHeaders(header), interceptor: nil, fileManager: FileManager.default).uploadProgress { progress in
//            uploadProgress?(progress)
//        }.responseObject { (response: DataResponse<T, AFError>) in
//            switch response.result {
//            case .success(let x):
//                self.handleStatusCode_ty(x, request: request, success: success, fail: fail)
//            case .failure(let error):
//                fail?(error as NSError)
//            }
//        }
//        let taskRequest: TYTaskRequestDelegate_ty = TYRequestModel_ty(request: task)
//        return taskRequest
//    }
//    
    // MARK: ==== Download ====
    /// 下载文件
    /// - Parameters:
    ///   - request: 请求体
    ///   - downloadProgress: 下载进度回调
    ///   - success: 下载成功回调
    ///   - fail: 下载失败回调
    @discardableResult
    public func httpDownloadRequestTask_ty (url: URL, downloadProgress: ((Progress) -> Void)?, success: ((_ response: Data) -> Void)?, fail: ((_ responseError: AFError) -> Void)?) -> TYTaskRequestDelegate_ty? {
        // 配置下载策略（全局搜索）
        let desctination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .allDomainsMask,  options: [.removePreviousFile, .createIntermediateDirectories])
        let task = AF.download(url, to: desctination).downloadProgress(queue: DispatchQueue.global()) { progress in
            // 下载进度
            downloadProgress?(progress)
        }.validate().responseData(queue: DispatchQueue.global()) { response in
            // 下载完成
            switch response.result {
            case .success(let data):
                success?(data)
            case .failure(let error):
                fail?(error)
            }
        }
        let taskRequest: TYTaskRequestDelegate_ty = TYRequestModel_ty(request: task)
        return taskRequest
    }
    
    // MARK: ==== Tools ====
    
    /// 检查网络是否正常
    /// - Returns: 是否正常
    private func checkNetwork_ty() -> Bool {
        // 是否有网络权限
        guard isNetworkAuth else {
            self.delegate_ty?.noAuthNetwork_ty()
            return false
        }
        // 是否有网络
        guard isReachable else {
            self.delegate_ty?.noNetwork_ty()
            return false
        }
        return true
    }
    
    /// 请求状态码逻辑处理
    /// - Parameters:
    ///   - response: 请求返回对象
    ///   - request: 请求对象
    ///   - success: 成功回调
    ///   - fail: 失败回调
    private func handleStatusCode_ty <T> (_ response: DataResponse <T, AFError>?, request: TYRequest_ty, success: ((_ response: T?) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: TYResopnse_ty {
        switch response?.result {
        case .success:
            if let responseDict = response?.data?.toJson(type: [String:Any].self) {
                var resultModel: T?
                // 如果需要加密
                if request.isEncrypt {
                    let dataStr = responseDict["data"] as? String
                    if let result = self.decryptResponse_ty(type: [String:Any].self, dataStr) {
                        resultModel = T(JSON: result)
                    }
                } else {
                    resultModel = T(JSON: responseDict)
                }
                resultModel?.response_ty = response?.response
                resultModel?.request_ty  = response?.request
                success?(resultModel)
            }
        case .failure(let error):
            print(error)
        case .none:
            print("Request error (_ty)")
        }
    }
    
    /// 确保参数key对应的Value不为空
    private func requestParametersReduceValueNil_ty(_ requestionParameters: [String : Any?]?) -> [String : Any]? {
        guard let parameters = requestionParameters else {
            return nil
        }
        let _parameters = parameters.reduce([String : Any]()) { (dict, e) in
            guard let value = e.1 else { return dict }
            var dict = dict
            dict[e.0] = value
            return dict
        }
        return _parameters
    }
    
    /// 解密
    /// - Parameters:
    ///   - type: 揭秘后的数据类型
    ///   - dataStr: 揭秘内容
    private func decryptResponse_ty<T>(type:T.Type, _ dataStr: String?) -> T? {
        guard let _dataStr = dataStr, let kData = "mzdjliebao81info".data(using: .utf8) else {
            return nil
        }
        let decodeData = NSData.convertHexStr(toData_ty: _dataStr)
        let decryptData = TYAESCryptor_ty.aes128Decrypt(withKey_ty: kData, data: decodeData)
        return decryptData.toJson(type: type)
    }
}

