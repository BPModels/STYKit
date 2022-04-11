//
//  TYLabel.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

open class TYLabel: UILabel {
    /// 内边距
    public var textInsets_ty: UIEdgeInsets?
    
    open override func drawText(in rect: CGRect) {
        guard let insets = self.textInsets_ty else {
            return super.drawText(in: rect)
        }
        super.drawText(in: rect.insetBy(dx: insets.left, dy: insets.top))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let insets = self.textInsets_ty, let _ = text else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        var rect = super.textRect(forBounds: bounds.insetBy(dx: insets.left, dy: insets.top), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom
        return rect
    }
    
    /// 设置文本同时指定行间距
    /// - Parameters:
    ///   - text: 内容
    ///   - space: 行间距
    public func setText_ty(text: String, line space: CGFloat) {
        self.text = text
        let style = NSMutableParagraphStyle()
        style.lineSpacing   = space
        style.lineBreakMode = self.lineBreakMode
        style.alignment     = self.textAlignment
        let attr = NSAttributedString(string: text, attributes: [.paragraphStyle : style])
        self.attributedText = attr
    }
}
