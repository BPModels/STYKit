//
//  TYFileManager_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/12.
//

import Foundation
import ObjectMapper

/// 文件管理器
public struct TYFileManager_ty {
    
    public static let share_ty = TYFileManager_ty()
    
    /// 保存资源文件
    /// - Parameters:
    ///   - name: 文件名称
    ///   - data: 资源数据
    /// - Returns: 是否保存成功
    @discardableResult
    public func saveFile_ty(name_ty: String, data_ty: Data) -> Bool {
        let path_ty = "\(normalPath_ty())/\(name_ty)"
        self.checkFile_ty(path_ty: path_ty)
        guard let fileHandle_ty = FileHandle(forWritingAtPath: path_ty) else {
            print("文件\(name_ty)写入失败:\(path_ty)")
            return false
        }
        fileHandle_ty.write(data_ty)
        return true
    }
    
    // TODO: ==== 用户头像缓存(公用) ====
    
    /// 保存头像文件
    /// - Parameters:
    ///   - urlStr: 头像网络地址
    ///   - userId: 用户ID
    ///   - data: 头像对象
    /// - Returns: 是否保存成功
    @discardableResult
    public func saveAvatar_ty(urlStr_ty: String, userId_ty: String, data_ty: Data) -> Bool {
        let dirPath_ty  = "\(avatarPath_ty(userId_ty: userId_ty))/"
        self.deleteDirectory_ty(path_ty: dirPath_ty)
        let urlHash_ty  = urlStr_ty.md5_ty()
        let filePath_ty = "\(avatarPath_ty(userId_ty: userId_ty))/\(urlHash_ty)"
        self.checkFile_ty(path_ty: filePath_ty)
        guard let fileHandle_ty = FileHandle(forWritingAtPath: filePath_ty) else {
            print("文件\(userId_ty)写入失败:\(filePath_ty)")
            return false
        }
        fileHandle_ty.write(data_ty)
        return true
    }
    
    /// 头像资源多用户共用
    /// - Parameters:
    ///   - urlStr: 头像网络地址
    ///   - userId: 用户ID
    /// - Returns: 头像本地文件
    public func receiveAvatar_ty(urlStr_ty: String, userId_ty: String) -> Data? {
        let urlHash_ty  = urlStr_ty.md5_ty()
        let filePath_ty = "\(avatarPath_ty(userId_ty: userId_ty))/\(urlHash_ty)"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath_ty) else {
            print("头像地址不存在,地址：\(filePath_ty)， url:\(urlStr_ty)")
            return nil
        }
        guard let fileHandle_ty = FileHandle(forReadingAtPath: filePath_ty) else {
            return nil
        }
        let data_ty = fileHandle_ty.readDataToEndOfFile()
        return data_ty
    }
    
    // TODO: ==== 聊天图片缓存(私用) ====
    
    /// 缓存聊天室内的多媒体资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称（唯一标识符即可）
    ///   - sessionId: 聊天室ID
    ///   - data: 多媒体数据
    /// - Returns: 保存路径
    @discardableResult
    public func saveSessionMedia_ty(type_ty: BPFileType_ty, name_ty: String, sessionId_ty: String, data_ty: Data, userId_ty: String) -> String? {
        let filePath_ty = self.getFilePath_ty(type_ty: type_ty, name_ty: name_ty, sessionId_ty: sessionId_ty, userId_ty: userId_ty)
        guard let fileHandle_ty = FileHandle(forWritingAtPath: filePath_ty) else {
            return nil
        }
        fileHandle_ty.write(data_ty)
        return filePath_ty
    }
    
    /// 获取聊天室内缓存的多媒体资源
    /// - Parameters:
    ///   - type_ty: 资源类型
    ///   - name_ty: 资源名称（唯一标识符即可）
    ///   - sessionId_ty: 聊天室ID
    /// - Returns: 多媒体资源对象
    public func getSessionMedia_ty(type_ty: BPFileType_ty, name_ty: String, sessionId_ty: String, userId_ty: String) -> Data? {
        let filePath_ty = self.getFilePath_ty(type_ty: type_ty, name_ty: name_ty, sessionId_ty: sessionId_ty, userId_ty: userId_ty)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath_ty) else {
            return nil
        }
        guard let fileHandle_ty = FileHandle(forReadingAtPath: filePath_ty) else {
            return nil
        }
        let data_ty = fileHandle_ty.readDataToEndOfFile()
        return data_ty
    }
    
    
    /// 删除会话中的某个资源
    /// - Parameters:
    ///   - type_ty: 资源类型
    ///   - name_ty: 资源名称
    ///   - sessionId_ty: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionMedia_ty(type_ty: BPFileType_ty, name_ty: String, sessionId_ty: String, userId_ty: String) -> Bool {
        let filePath_ty = self.getFilePath_ty(type_ty: type_ty, name_ty: name_ty, sessionId_ty: sessionId_ty, userId_ty: userId_ty)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath_ty) else {
            print("==文件== 删除文件失败:\(filePath_ty)")
            return true
        }
        let result_ty = self.deleteFile_ty(path_ty: filePath_ty)
        if result_ty {
            print("==文件== 删除文件成功:\(filePath_ty)")
        } else {
            print("==文件== 删除文件失败:\(filePath_ty)")
        }
        return result_ty
    }
    
    /// 删除会话中所有资源
    /// - Parameter sessionId_ty: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionAllMedias_ty(sessionId_ty: String, userId_ty: String) -> Bool {
        let _sessionPath_ty = self.getSessionPath_ty(sessionId_ty: sessionId_ty, userId_ty: userId_ty)
        return self.deleteDirectory_ty(path_ty: _sessionPath_ty)
    }
 
    // TODO: ==== 聊天语音缓存 ====
    
    /// 缓存聊天室语音
    /// - Parameters:
    ///   - imageData_ty: 语音
    ///   - sessionId_ty: 聊天室ID
    ///   - name_ty: 语音名称
    /// - Returns: 本地地址
    @discardableResult
    public func saveSessionAudio_ty(audioData_ty: Data, sessionId_ty: String, name_ty: String, userId_ty: String) -> String? {
        let filePath_ty = "\(sessionAudioPath_ty(sessionId_ty: sessionId_ty, userId_ty: userId_ty))/\(name_ty).aac"
        self.checkFile_ty(path_ty: filePath_ty)
        guard let fileHandle_ty = FileHandle(forWritingAtPath: filePath_ty) else {
            print("文件\(name_ty)写入失败:\(filePath_ty)")
            return nil
        }
        fileHandle_ty.write(audioData_ty)
        return filePath_ty
    }
    
    /// 获取聊天室本地缓存语音
    /// - Parameters:
    ///   - sessionId: 聊天室ID
    ///   - name: 语音名称
    /// - Returns: 图片
    public func receiveSessionAudio_ty(sessionId_ty: String, name_ty: String, userId_ty: String) -> Data? {
        let filePath_ty = "\(sessionAudioPath_ty(sessionId_ty: sessionId_ty, userId_ty: userId_ty))/\(name_ty).aac"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath_ty) else {
            return nil
        }
        guard let fileHandle_ty = FileHandle(forReadingAtPath: filePath_ty) else {
            return nil
        }
        let data_ty = fileHandle_ty.readDataToEndOfFile()
        return data_ty
    }
    
    // TODO: ==== 本地文件操作 ====
    
    /// 获取本地转换单个对象
    /// - Parameters:
    ///   - name: 文件名
    ///   - type: 类型
    /// - Returns: 对象
    func getJsonModel_ty(file_ty name_ty: String, type_ty: Mappable.Type) -> Mappable? {
        guard let path_ty = Bundle.main.path(forResource: name_ty, ofType: "json") else {
            return nil
        }
        do {
            let json_ty = try String(contentsOfFile: path_ty, encoding: .utf8)
            guard let data_ty = json_ty.data(using: .utf8) else {
                return nil
            }
            guard let jsonDic_ty = try JSONSerialization.jsonObject(with: data_ty, options: .fragmentsAllowed) as? [String:Any] else {
                return nil
            }
            return type_ty.init(JSON: jsonDic_ty)
        } catch let error_ty {
            print("get json error: \(error_ty)")
        }
        return nil
    }
    
    /// 获取本地对象列表
    /// - Parameters:
    ///   - name: 文件名
    ///   - type: 类型
    /// - Returns: 对象列表
    func getJsonModelList_ty(file_ty name_ty: String, type_ty: Mappable.Type) -> [Mappable] {
        guard let path_ty = Bundle.main.path(forResource: name_ty, ofType: "json") else {
            return []
        }
        do {
            let json_ty = try String(contentsOfFile: path_ty, encoding: .utf8)
            guard let data_ty = json_ty.data(using: .utf8) else {
                return []
            }
            guard let jsonArray_ty = try JSONSerialization.jsonObject(with: data_ty, options: .fragmentsAllowed) as? [[String:Any]] else {
                return []
            }
            var modelList_ty = [Mappable]()
            jsonArray_ty.forEach { dict_ty in
                if let model_ty = type_ty.init(JSON: dict_ty) {
                    modelList_ty.append(model_ty)
                }
            }
            return modelList_ty
        } catch let error_ty {
            print("get json error: \(error_ty)")
        }
        return []
    }
    
    // TODO: ==== Tools ====
    
    public enum BPFileType_ty: String {
        case sessionImage_ty = "Image_ty"
        case sessionAudio_ty = "Audio_ty"
    }
    
    /// 录制的音频文件路径
    public var voicePath_ty: String {
        let path_ty = documentPath_ty() + "/Voice"
        self.checkDirectory_ty(path_ty: path_ty)
        return path_ty
    }

    /// 默认资源存放路径
    /// - Returns: 路径地址
    private func normalPath_ty() -> String {
        let path_ty = documentPath_ty() + "/Normal"
        self.checkDirectory_ty(path_ty: path_ty)
        return path_ty
    }
    
    /// 头像资源存放路径
    /// - Returns: 路径地址
    private func avatarPath_ty(userId_ty: String) -> String {
        let path_ty = documentPath_ty() + "/Avatar/\(userId_ty)"
        self.checkDirectory_ty(path_ty: path_ty)
        return path_ty
    }
    
    /// 聊天室中图片存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionImagePath_ty(sessionId_ty: String, userId_ty: String) -> String {
        let path_ty = documentPath_ty() + "/Chat_\(userId_ty)/Images/\(sessionId_ty)"
        self.checkDirectory_ty(path_ty: path_ty)
        return path_ty
    }
    
    /// 聊天室中语音存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionAudioPath_ty(sessionId_ty: String, userId_ty: String) -> String {
        let path_ty = documentPath_ty() + "/\(userId_ty)/Audios/\(sessionId_ty)"
        self.checkDirectory_ty(path_ty: path_ty)
        return path_ty
    }
    
    /// 云盘文件(夹)路径
    public func cloudPath_ty(folderName_ty:String, fileName_ty:String? = nil) -> String {
        var path_ty = documentPath_ty() + "/cloud/\(folderName_ty)"
        if let fileName_ty = fileName_ty {
            path_ty.append("/\(fileName_ty)")
        }
        return path_ty
    }
    
    /// 文档路径
    /// - Returns: 路径地址
    func documentPath_ty() -> String {
        var documentPath_ty = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if documentPath_ty == "" {
            documentPath_ty = NSHomeDirectory() + "/Documents"
            self.checkDirectory_ty(path_ty: documentPath_ty)
            return documentPath_ty
        }
        return documentPath_ty
    }

    /// 检查文件夹是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkDirectory_ty(path_ty: String) {
        if !FileManager.default.fileExists(atPath: path_ty) {
            do {
                try FileManager.default.createDirectory(atPath: path_ty, withIntermediateDirectories: true, attributes: nil)
            } catch let error_ty {
                print("==文件==创建目录:\(path_ty),失败：\(error_ty)")
            }
        }
    }

    /// 检查文件是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkFile_ty(path_ty: String) {
        if !FileManager.default.fileExists(atPath: path_ty) {
            let result_ty = FileManager.default.createFile(atPath: path_ty, contents: nil, attributes: nil)
            if result_ty {
                print("==文件==创建文件成功：\(path_ty)")
            } else {
                print("==文件==创建文件失败：\(path_ty)")
            }
        }
    }
    
    /// 删除文件夹
    /// - Parameter path: 路径
    @discardableResult
    func deleteDirectory_ty(path_ty: String) -> Bool {
        var result_ty = false
        if FileManager.default.fileExists(atPath: path_ty) {
            let manager_ty = FileManager.default
            result_ty = manager_ty.isDeletableFile(atPath: path_ty)
            if result_ty {
                do {
                    try manager_ty.removeItem(atPath: path_ty)
                    print("==文件==删除本地文件夹成功")
                } catch let error_ty {
                    print("==文件==删除本地文件夹失败：\(error_ty)")
                }
            }
        }
        return result_ty
    }
    
    /// 删除文件
    /// - Parameter path: 文件路径
    /// - Returns: 是否删除成功
    func deleteFile_ty(path_ty: String) -> Bool {
        if FileManager.default.fileExists(atPath: path_ty) {
            let manager_ty = FileManager.default
            let result_ty  = manager_ty.isDeletableFile(atPath: path_ty)
            if result_ty {
                do {
                    try manager_ty.removeItem(atPath: path_ty)
                    return true
                } catch let error_ty {
                    print("删除本地文件失败：\(error_ty)")
                    return false
                }
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    /// 获取会话资源地址
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称
    ///   - sessionId: 会话ID
    /// - Returns: 资源地址
    private func getFilePath_ty(type_ty: BPFileType_ty, name_ty: String, sessionId_ty: String, userId_ty: String) -> String {
        let _sessionPath_ty  = self.getSessionPath_ty(sessionId_ty: sessionId_ty, userId_ty: userId_ty)
        let directoryPath_ty = _sessionPath_ty + "/\(type_ty.rawValue)"
        self.checkDirectory_ty(path_ty: directoryPath_ty)
        let nameHash_ty = name_ty.md5_ty()
        let filePath_ty = directoryPath_ty + "/\(nameHash_ty)"
        self.checkFile_ty(path_ty: filePath_ty)
        return filePath_ty
    }
    
    /// 获取会话缓存地址
    /// - Parameters:
    ///   - sessionId: 会话ID
    /// - Returns: 会话缓存目录
    private func getSessionPath_ty(sessionId_ty: String, userId_ty: String) -> String {
        let sessionPath_ty = documentPath_ty() + "/Chat_\(userId_ty)/\(sessionId_ty)"
        self.checkDirectory_ty(path_ty: sessionPath_ty)
        return sessionPath_ty
    }
}

