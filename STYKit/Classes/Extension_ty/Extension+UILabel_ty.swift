//
//  Extension+UILabel.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public extension UILabel {
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight_ty(width_ty: CGFloat) -> CGFloat {
        guard let _text_ty = self.text, let _font_ty = self.font else { return .zero}
        let rect_ty = NSString(string: _text_ty).boundingRect(with: CGSize(width: width_ty, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: _font_ty], context: nil)
        return ceil(rect_ty.height)
    }
}
