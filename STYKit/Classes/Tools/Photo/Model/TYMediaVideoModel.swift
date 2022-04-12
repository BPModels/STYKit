//
//  TYMediaVideoModel.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

/// 视频资源
public class TYMediaVideoModel: TYMediaModel {

    /// 视频本地地址
    public var videoLocalPath_ty: String?
    /// 视频网络地址
    public var videoRemotePath_ty: String?
    /// 封面截图本地地址
    public var coverPath_ty: String?
    /// 封面截图远端地址
    public var coverUrl_ty: String?
    /// 封面截图尺寸
    public var coverSize_ty: CGSize?
    /// 视频资源对象
    public var data_ty: Data?
    /// 时长
    public var time_ty: TimeInterval = .zero
}
