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
    public func saveFile_ty(name: String, data: Data) -> Bool {
        let path = "\(normalPath_ty())/\(name)"
        self.checkFile_ty(path: path)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            print("文件\(name)写入失败:\(path)")
            return false
        }
        fileHandle.write(data)
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
    public func saveAvatar_ty(urlStr: String, userId: String, data: Data) -> Bool {
        let dirPath  = "\(avatarPath_ty(userId: userId))/"
        self.deleteDirectory_ty(path: dirPath)
        let urlHash  = urlStr.md5_ty()
        let filePath = "\(avatarPath_ty(userId: userId))/\(urlHash)"
        self.checkFile_ty(path: filePath)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            print("文件\(userId)写入失败:\(filePath)")
            return false
        }
        fileHandle.write(data)
        return true
    }
    
    /// 头像资源多用户共用
    /// - Parameters:
    ///   - urlStr: 头像网络地址
    ///   - userId: 用户ID
    /// - Returns: 头像本地文件
    public func receiveAvatar_ty(urlStr: String, userId: String) -> Data? {
        let urlHash  = urlStr.md5_ty()
        let filePath = "\(avatarPath_ty(userId: userId))/\(urlHash)"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("头像地址不存在,地址：\(filePath)， url:\(urlStr)")
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
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
    public func saveSessionMedia_ty(type: BPFileType, name: String, sessionId: String, data: Data, userId: String) -> String? {
        let filePath = self.getFilePath_ty(type: type, name: name, sessionId: sessionId, userId: userId)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            return nil
        }
        fileHandle.write(data)
        return filePath
    }
    
    /// 获取聊天室内缓存的多媒体资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称（唯一标识符即可）
    ///   - sessionId: 聊天室ID
    /// - Returns: 多媒体资源对象
    public func getSessionMedia_ty(type: BPFileType, name: String, sessionId: String, userId: String) -> Data? {
        let filePath = self.getFilePath_ty(type: type, name: name, sessionId: sessionId, userId: userId)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
    
    
    /// 删除会话中的某个资源
    /// - Parameters:
    ///   - type: 资源类型
    ///   - name: 资源名称
    ///   - sessionId: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionMedia_ty(type: BPFileType, name: String, sessionId: String, userId: String) -> Bool {
        let filePath = self.getFilePath_ty(type: type, name: name, sessionId: sessionId, userId: userId)
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            print("==文件== 删除文件失败:\(filePath)")
            return true
        }
        let result = self.deleteFile_ty(path: filePath)
        if result {
            print("==文件== 删除文件成功:\(filePath)")
        } else {
            print("==文件== 删除文件失败:\(filePath)")
        }
        return result
    }
    
    /// 删除会话中所有资源
    /// - Parameter sessionId: 会话ID
    /// - Returns: 是否删除成功
    @discardableResult
    public func deleteSessionAllMedias_ty(sessionId: String, userId: String) -> Bool {
        let _sessionPath = self.getSessionPath_ty(sessionId: sessionId, userId: userId)
        return self.deleteDirectory_ty(path: _sessionPath)
    }
 
    // TODO: ==== 聊天语音缓存 ====
    
    /// 缓存聊天室语音
    /// - Parameters:
    ///   - imageData: 语音
    ///   - sessionId: 聊天室ID
    ///   - name: 语音名称
    /// - Returns: 本地地址
    @discardableResult
    public func saveSessionAudio_ty(audioData: Data, sessionId: String, name: String, userId: String) -> String? {
        let filePath = "\(sessionAudioPath_ty(sessionId: sessionId, userId: userId))/\(name).aac"
        self.checkFile_ty(path: filePath)
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            print("文件\(name)写入失败:\(filePath)")
            return nil
        }
        fileHandle.write(audioData)
        return filePath
    }
    
    /// 获取聊天室本地缓存语音
    /// - Parameters:
    ///   - sessionId: 聊天室ID
    ///   - name: 语音名称
    /// - Returns: 图片
    public func receiveSessionAudio_ty(sessionId: String, name: String, userId: String) -> Data? {
        let filePath = "\(sessionAudioPath_ty(sessionId: sessionId, userId: userId))/\(name).aac"
        // 检测文件是否存在
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        let data = fileHandle.readDataToEndOfFile()
        return data
    }
    
    // TODO: ==== 本地文件操作 ====
    
    /// 获取本地转换单个对象
    /// - Parameters:
    ///   - name: 文件名
    ///   - type: 类型
    /// - Returns: 对象
    func getJsonModel_ty(file name: String, type: Mappable.Type) -> Mappable? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            return nil
        }
        do {
            let json = try String(contentsOfFile: path, encoding: .utf8)
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            guard let jsonDic = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any] else {
                return nil
            }
            return type.init(JSON: jsonDic)
        } catch let error {
            print("get json error: \(error)")
        }
        return nil
    }
    
    /// 获取本地对象列表
    /// - Parameters:
    ///   - name: 文件名
    ///   - type: 类型
    /// - Returns: 对象列表
    func getJsonModelList_ty(file name: String, type: Mappable.Type) -> [Mappable] {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            return []
        }
        do {
            let json = try String(contentsOfFile: path, encoding: .utf8)
            guard let data = json.data(using: .utf8) else {
                return []
            }
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [[String:Any]] else {
                return []
            }
            var modelList = [Mappable]()
            jsonArray.forEach { dict in
                if let model = type.init(JSON: dict) {
                    modelList.append(model)
                }
            }
            return modelList
        } catch let error {
            print("get json error: \(error)")
        }
        return []
    }
    
    // TODO: ==== Tools ====
    
    public enum BPFileType: String {
        case sessionImage = "Image"
        case sessionAudio = "Audio"
    }
    
    /// 录制的音频文件路径
    public var voicePath_ty: String {
        let path = documentPath_ty() + "/Voice"
        self.checkDirectory_ty(path: path)
        return path
    }

    /// 默认资源存放路径
    /// - Returns: 路径地址
    private func normalPath_ty() -> String {
        let path = documentPath_ty() + "/Normal"
        self.checkDirectory_ty(path: path)
        return path
    }
    
    /// 头像资源存放路径
    /// - Returns: 路径地址
    private func avatarPath_ty(userId: String) -> String {
        let path = documentPath_ty() + "/Avatar/\(userId)"
        self.checkDirectory_ty(path: path)
        return path
    }
    
    /// 聊天室中图片存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionImagePath_ty(sessionId: String, userId: String) -> String {
        let path = documentPath_ty() + "/Chat_\(userId)/Images/\(sessionId)"
        self.checkDirectory_ty(path: path)
        return path
    }
    
    /// 聊天室中语音存储路径
    /// - Parameter sessionId: 会话ID
    /// - Returns: 路径地址
    private func sessionAudioPath_ty(sessionId: String, userId: String) -> String {
        let path = documentPath_ty() + "/\(userId)/Audios/\(sessionId)"
        self.checkDirectory_ty(path: path)
        return path
    }
    
    /// 云盘文件(夹)路径
    public func cloudPath_ty(folderName:String, fileName:String? = nil) -> String {
        var path = documentPath_ty() + "/cloud/\(folderName)"
        if let fileName = fileName{
            path.append("/\(fileName)")
        }
        return path
    }
    
    /// 文档路径
    /// - Returns: 路径地址
    func documentPath_ty() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if documentPath == "" {
            documentPath = NSHomeDirectory() + "/Documents"
            self.checkDirectory_ty(path: documentPath)
            return documentPath
        }
        return documentPath
    }

    /// 检查文件夹是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkDirectory_ty(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("==文件==创建目录:\(path),失败：\(error)")
            }
        }
    }

    /// 检查文件是否存在，不存在则创建
    /// - Parameter path: 文件路径
    func checkFile_ty(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            let result = FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
            if result {
                print("==文件==创建文件成功：\(path)")
            } else {
                print("==文件==创建文件失败：\(path)")
            }
        }
    }
    
    /// 删除文件夹
    /// - Parameter path: 路径
    @discardableResult
    func deleteDirectory_ty(path: String) -> Bool {
        var result = false
        if FileManager.default.fileExists(atPath: path) {
            let manager = FileManager.default
            result  = manager.isDeletableFile(atPath: path)
            if result {
                do {
                    try manager.removeItem(atPath: path)
                    print("==文件==删除本地文件夹成功")
                } catch let error {
                    print("==文件==删除本地文件夹失败：\(error)")
                }
            }
        }
        return result
    }
    
    /// 删除文件
    /// - Parameter path: 文件路径
    /// - Returns: 是否删除成功
    func deleteFile_ty(path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            let manager = FileManager.default
            let result  = manager.isDeletableFile(atPath: path)
            if result {
                do {
                    try manager.removeItem(atPath: path)
                    return true
                } catch let error {
                    print("删除本地文件失败：\(error)")
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
    private func getFilePath_ty(type: BPFileType, name: String, sessionId: String, userId: String) -> String {
        let _sessionPath  = self.getSessionPath_ty(sessionId: sessionId, userId: userId)
        let directoryPath = _sessionPath + "/\(type.rawValue)"
        self.checkDirectory_ty(path: directoryPath)
        let nameHash = name.md5_ty()
        let filePath = directoryPath + "/\(nameHash)"
        self.checkFile_ty(path: filePath)
        return filePath
    }
    
    /// 获取会话缓存地址
    /// - Parameters:
    ///   - sessionId: 会话ID
    /// - Returns: 会话缓存目录
    private func getSessionPath_ty(sessionId: String, userId: String) -> String {
        let sessionPath = documentPath_ty() + "/Chat_\(userId)/\(sessionId)"
        self.checkDirectory_ty(path: sessionPath)
        return sessionPath
    }
}

