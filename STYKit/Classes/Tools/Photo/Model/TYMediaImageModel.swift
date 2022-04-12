//
//  TYMediaImageModel.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//


import ObjectMapper
import Photos

/// 图片资源
public class TYMediaImageModel: TYMediaModel {
    
    /// 图片压缩格式
    public enum TYImageCompressFormat: Int {
        case jpeg_ty
        case png_ty
    }

    /// 图片
    public var image_ty: UIImage?
    /// 缩略图本地地址
    public var thumbnailLocalPath_ty: String?
    /// 缩略图网络地址
    public var thumbnailRemotePath_ty: String?
    /// 原图本地地址
    public var originLocalPath_ty: String?
    /// 原图网络地址
    public var originRemotePath_ty: String?
    /// 图片尺寸
    public var imageSize_ty: CGSize = .zero
    /// 压缩比例
    public var compressQuality_ty: CGFloat?
    /// 压缩格式
    public var compressFormat_ty: TYImageCompressFormat?
    /// 原始Data
    public var data_ty: Data?
}
