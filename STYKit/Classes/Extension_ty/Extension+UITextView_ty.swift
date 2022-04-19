//
//  Extension+UITextView.swift
//  STYKit
//
//  Created by apple on 2022/4/19.
//

import Foundation

public extension UITextView {
    
    private struct TextViewMenu_ty {
        static var disableMenu_ty = "disableMenu_ty"
    }
    
    /// 是否在播放中
    var disableMenu_ty: Bool {
        get {
            return objc_getAssociatedObject(self, &TextViewMenu_ty.disableMenu_ty) as? Bool ?? false
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &TextViewMenu_ty.disableMenu_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 设置光标位置
    func setPosition_ty(offset_ty: Int) {
        // 先移到文首
        let begin_ty = self.beginningOfDocument
        guard let start_ty = self.position(from: begin_ty, offset: 0) else { return }
        let startRange_ty  = self.textRange(from: start_ty, to: start_ty)
        self.selectedTextRange = startRange_ty
        // 移动到正确位置
        guard let selectedRange_ty = self.selectedTextRange else { return }
        var currentOffset_ty = self.offset(from: self.beginningOfDocument, to: selectedRange_ty.start)
        currentOffset_ty += offset_ty
        guard let newPosition_ty = self.position(from: self.beginningOfDocument, offset: currentOffset_ty) else { return }
        self.selectedTextRange = self.textRange(from: newPosition_ty, to: newPosition_ty)
    }
    
    /// 获得光标位置
    func getPosition_ty() -> Int {
        guard let range_ty = self.selectedTextRange else {
            return self.text.count
        }
        let index_ty = self.offset(from: self.beginningOfDocument, to: range_ty.start)
        return index_ty
    }
    
    /// 转换NSRange 到 UITextRange
    func transformRange_ty(range_ty: NSRange) -> UITextRange? {
        let beginning_ty = self.beginningOfDocument
        guard let startPosition_ty = self.position(from: beginning_ty, offset: range_ty.location), let endPosition_ty = self.position(from: beginning_ty, offset: range_ty.location + range_ty.length) else {
            return nil
        }
        let _textRange_ty = self.textRange(from: startPosition_ty, to: endPosition_ty)
        return _textRange_ty
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.disableMenu_ty {
            UIMenuController.shared.isMenuVisible = false
            self.selectedRange = NSRange.init(location: 0, length: 0)
            return false
        }
        if action == #selector(selectAll) ||
            action == #selector(select) ||
            action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) ||
            action == #selector(paste(_:)) {
            super.canPerformAction(action, withSender: sender)
            return true
        }
        return false
        
    }
}
