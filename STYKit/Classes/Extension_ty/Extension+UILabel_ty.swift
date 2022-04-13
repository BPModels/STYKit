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
    func textHeight_ty(width: CGFloat) -> CGFloat {
        guard let _text = self.text, let _font = self.font else { return .zero}
        let rect = NSString(string: _text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: _font], context: nil)
        return ceil(rect.height)
    }
}
