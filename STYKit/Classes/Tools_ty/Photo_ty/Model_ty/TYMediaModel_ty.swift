//
//  TYMediaModel_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import ObjectMapper
import Photos

public class TYMediaModel_ty: Mappable, Equatable {
    
    /// 资源ID
    public var id_ty: String = ""
    /// 资源名称
    public var name_ty: String = ""
    /// 聊天室消息ID（仅用于IM）
    public var messageId_ty: String?
    /// 聊天室ID（仅用于IM）
    public var sessionId_ty: String?
    /// 资源类型
    public var type_ty: TYMediaType = .image_ty(type: .image_ty)
    /// 图片MD5
    public var md5_ty: String?
    /// 文件大小
    public var fileLength_ty: Int = .zero
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
    }
    
    // MARK: ==== Tools ====
    public static func == (lhs: TYMediaModel_ty, rhs: TYMediaModel_ty) -> Bool {
        return lhs.id_ty == rhs.id_ty
    }
}

public enum TYMediaType {
    /// 图片
    case image_ty(type: TYMediaImageType)
    /// 视频
    case video_ty
    /// 音频
    case audio_ty
    /// 文件
    case file_ty
}


public enum TYMediaImageType {
    /// 头像
    case icon_ty
    /// 地图消息
    case mapMessage_ty
    /// 缩略图
    case thumbImage_ty
    /// 大图（压缩后）
    case image_ty
    /// 原图（未压缩）
    case originImage_ty
    
    public var typeStr: String {
        get {
            switch self {
            case .icon_ty:
                return "_pic_icon"
            case .mapMessage_ty:
                return "_pic_map"
            case .thumbImage_ty:
                return "_pic_thum"
            case .image_ty:
                return "_pic"
            case .originImage_ty:
                return "_pic_hd"
            }
        }
    }
}
