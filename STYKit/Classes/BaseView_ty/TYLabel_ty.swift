//
//  TYLabel_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

public class TYLabel_ty: UILabel {
    /// 内边距
    public var textInsets_ty: UIEdgeInsets?
    
    open override func drawText(in rect: CGRect) {
        guard let insets_ty = self.textInsets_ty else {
            return super.drawText(in: rect)
        }
        super.drawText(in: rect.insetBy(dx: insets_ty.left, dy: insets_ty.top))
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        guard let insets_ty = self.textInsets_ty, let _ = text else {
            return super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        }
        var rect_ty = super.textRect(forBounds: bounds.insetBy(dx: insets_ty.left, dy: insets_ty.top), limitedToNumberOfLines: numberOfLines)
        rect_ty.origin.x    -= insets_ty.left
        rect_ty.origin.y    -= insets_ty.top
        rect_ty.size.width  += insets_ty.left + insets_ty.right
        rect_ty.size.height += insets_ty.top  + insets_ty.bottom
        return rect_ty
    }
    
    /// 设置文本同时指定行间距
    /// - Parameters:
    ///   - text: 内容
    ///   - space: 行间距
    public func setText_ty(text_ty: String, line_ty space_ty: CGFloat) {
        self.text = text_ty
        let style_ty = NSMutableParagraphStyle()
        style_ty.lineSpacing   = space_ty
        style_ty.lineBreakMode = self.lineBreakMode
        style_ty.alignment     = self.textAlignment
        let attr_ty = NSAttributedString(string: text_ty, attributes: [.paragraphStyle : style_ty])
        self.attributedText = attr_ty
    }
}
