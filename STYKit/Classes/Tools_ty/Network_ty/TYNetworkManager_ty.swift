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
    func handleStatusCode_ty(code_ty: Int) -> Bool
    /// 处理错误内容（如果返回true，则不调用success或fail回调）
    /// - Parameter message: 错误内容
    /// - Returns: 是否已处理
    func handleErrorMessage_ty(message_ty: String) -> Bool
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
    public func request_ty <T> (_ type_ty: T.Type, request_ty: TYRequest_ty, success_ty: ((_ response_ty: T?) -> Void)?, fail_ty: ((_ responseError_ty: NSError?) -> Void)?) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 检测网络
        guard checkNetwork_ty() else {
            fail_ty?(nil)
            return nil
        }
        switch request_ty.method_ty {
        case .post_ty:
            // 发起请求，并返回请求体
            return self.httpPostRequest_ty(type_ty, request_ty: request_ty) { (response_ty) in
                // 处理Code
                self.handleStatusCode_ty(response_ty, request_ty: request_ty, success_ty: success_ty, fail_ty: fail_ty)
            }
        case .get_ty:
            return self.httpGetRequest_ty(type_ty, request_ty: request_ty) { (response_ty) in
                self.handleStatusCode_ty(response_ty, request_ty: request_ty, success_ty: success_ty, fail_ty: fail_ty)
            }
        case .put_ty:
            return self.httpPutRequest_ty(type_ty, request_ty: request_ty) { (response_ty) in
                self.handleStatusCode_ty(response_ty, request_ty: request_ty, success_ty: success_ty, fail_ty: fail_ty)
            }
        default:
            fail_ty?(nil)
            return nil
        }
    }
  
    // TODO: ---- POST ----
    @discardableResult
    private func httpPostRequest_ty <T> (_ type_ty: T.Type, request_ty: TYRequest_ty, handle_ty:@escaping (_ response_ty: DataResponse <T, AFError>?) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url_ty = request_ty.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters_ty = requestParametersReduceValueNil_ty(request_ty.parameters_ty)
        // 添加Header
        var _request_ty = URLRequest(url: url_ty)
        _request_ty.httpMethod          = request_ty.method_ty.rawValue
        _request_ty.allHTTPHeaderFields = request_ty.header_ty
        // 是否加密
        _request_ty.allHTTPHeaderFields?["_security_"] = request_ty.isEncrypt ? "1" : "0"
        do {
            // 添加参数
            if let _parameters_ty = parameters_ty {
                try _request_ty.httpBody = JSONSerialization.data(withJSONObject: _parameters_ty, options: [])
            }
            // 发起请求
            let request_ty = AF.request(_request_ty).responseObject { (response_ty: DataResponse<T, AFError>) in
                handle_ty(response_ty)
            }
            
            // 返回请求体
            let taskRequest_ty: TYTaskRequestDelegate_ty = TYRequestModel_ty(request_ty: request_ty)
            return taskRequest_ty
        } catch let error_ty {
            print("Post request error: \(error_ty)  (_ty)")
            handle_ty(nil)
            return nil
        }
    }
    
    // TODO: ---- GET ----
    @discardableResult
    private func httpGetRequest_ty <T>(_ type_ty: T.Type, request_ty: TYRequest_ty, handle_ty:@escaping (_ response_ty: DataResponse <T, AFError>?) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url_ty = request_ty.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters_ty = requestParametersReduceValueNil_ty(request_ty.parameters_ty)
        // 发起请求
        let task_ty = AF.request(url_ty, method: HTTPMethod.get, parameters: parameters_ty, encoding: URLEncoding.default, headers: HTTPHeaders(request_ty.header_ty)).responseObject { (response_ty: DataResponse <T, AFError>) in
            handle_ty(response_ty)
        }
        let taskRequest_ty: TYTaskRequestDelegate_ty = TYRequestModel_ty(request_ty: task_ty)
        return taskRequest_ty
    }
    
    // TODO: ---- PUT ----
    @discardableResult
    private func httpPutRequest_ty <T>(_ type_ty: T.Type, request_ty: TYRequest_ty, handle_ty:@escaping (_ response_ty: DataResponse <T, AFError>) -> Void) -> TYTaskRequestDelegate_ty? where T: TYResopnse_ty {
        // 校验url
        guard let url_ty = request_ty.url_ty else {
            return nil
        }
        // 校验参数（移除Value为空的参数）
        let parameters_ty = requestParametersReduceValueNil_ty(request_ty.parameters_ty)
        // 发起请求
        let task_ty = AF.request(url_ty, method: HTTPMethod.put, parameters: parameters_ty, encoding: URLEncoding.default, headers: HTTPHeaders(request_ty.header_ty)).responseObject { (response_ty: DataResponse <T, AFError>) in
            handle_ty(response_ty)
        }
        let taskRequest_ty: TYTaskRequestDelegate_ty = TYRequestModel_ty(request_ty: task_ty)
        return taskRequest_ty
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
    public func httpDownloadRequestTask_ty (url_ty: URL, downloadProgress_ty: ((Progress) -> Void)?, success_ty: ((_ response_ty: Data) -> Void)?, fail_ty: ((_ responseError_ty: AFError) -> Void)?) -> TYTaskRequestDelegate_ty? {
        // 配置下载策略（全局搜索）
        let desctination_ty = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .allDomainsMask,  options: [.removePreviousFile, .createIntermediateDirectories])
        let task_ty = AF.download(url_ty, to: desctination_ty).downloadProgress(queue: DispatchQueue.global()) { progress_ty in
            // 下载进度
            downloadProgress_ty?(progress_ty)
        }.validate().responseData(queue: DispatchQueue.global()) { response_ty in
            // 下载完成
            switch response_ty.result {
            case .success(let data_ty):
                success_ty?(data_ty)
            case .failure(let error_ty):
                fail_ty?(error_ty)
            }
        }
        let taskRequest_ty: TYTaskRequestDelegate_ty = TYRequestModel_ty(request_ty: task_ty)
        return taskRequest_ty
    }
    
    // MARK: ==== Tools ====
    
    /// 检查网络是否正常
    /// - Returns: 是否正常
    private func checkNetwork_ty() -> Bool {
        // 是否有网络权限
        guard isNetworkAuth_ty else {
            self.delegate_ty?.noAuthNetwork_ty()
            return false
        }
        // 是否有网络
        guard isReachable_ty else {
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
    private func handleStatusCode_ty <T> (_ response_ty: DataResponse <T, AFError>?, request_ty: TYRequest_ty, success_ty: ((_ response_ty: T?) -> Void)?, fail_ty: ((_ responseError_ty: NSError) -> Void)?) -> Void where T: TYResopnse_ty {
        switch response_ty?.result {
        case .success:
            if let responseDict_ty = response_ty?.data?.toJson_ty(type_ty: [String:Any].self) {
                var resultModel_ty: T?
                // 如果需要加密
                if request_ty.isEncrypt {
                    let dataStr_ty = responseDict_ty["data"] as? String
                    if let result_ty = self.decryptResponse_ty(type_ty: [String:Any].self, dataStr_ty) {
                        resultModel_ty = T(JSON: result_ty)
                    }
                } else {
                    resultModel_ty = T(JSON: responseDict_ty)
                }
                resultModel_ty?.response_ty = response_ty?.response
                resultModel_ty?.request_ty  = response_ty?.request
                success_ty?(resultModel_ty)
            }
        case .failure(let error_ty):
            print(error_ty)
        case .none:
            print("Request error (_ty)")
        }
    }
    
    /// 确保参数key对应的Value不为空
    private func requestParametersReduceValueNil_ty(_ requestionParameters_ty: [String : Any?]?) -> [String : Any]? {
        guard let parameters_ty = requestionParameters_ty else {
            return nil
        }
        let _parameters_ty = parameters_ty.reduce([String : Any]()) { (dict_ty, e_ty) in
            guard let value_ty = e_ty.1 else { return dict_ty }
            var dict_ty = dict_ty
            dict_ty[e_ty.0] = value_ty
            return dict_ty
        }
        return _parameters_ty
    }
    
    /// 解密
    /// - Parameters:
    ///   - type: 揭秘后的数据类型
    ///   - dataStr: 揭秘内容
    private func decryptResponse_ty<T>(type_ty:T.Type, _ dataStr_ty: String?) -> T? {
        guard let _dataStr_ty = dataStr_ty, let kData_ty = "mzdjliebao81info".data(using: .utf8) else {
            return nil
        }
        let decodeData_ty = NSData.convertHexStr(toData_ty: _dataStr_ty)
        let decryptData_ty = TYAESCryptor_ty.aes128Decrypt(withKey_ty: kData_ty, data_ty: decodeData_ty)
        return decryptData_ty.toJson_ty(type_ty: type_ty)
    }
}

