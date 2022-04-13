//
//  TYTextField_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public enum TYTextFieldType_ty {
    case normal
    case number
    case password
}

open class TYTextField_ty: UITextField, UITextFieldDelegate {
    
    public var type_ty: TYTextFieldType_ty
    public var maxCount_ty: Int = .max
    public var editingBlock_ty: StringBlock_ty?
    public var editFinishedBlock_ty: StringBlock_ty?
    
    /// 显示左边空白视图（左边边距）
    public var showLeftView_ty: Bool {
        willSet {
            if newValue {
                let _leftView = TYView_ty(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize_ty(15), height: AdaptSize_ty(1))))
                _leftView.backgroundColor = UIColor.clear
                self.leftView     = _leftView
                self.leftViewMode = .always
            } else {
                self.leftView     = nil
                self.leftViewMode = .never
            }
        }
    }
    /// 显示边框
    public var showBorder_ty: Bool = false {
        willSet {
            if newValue {
                self.layer.borderWidth  = AdaptSize_ty(0.6)
                self.layer.borderColor  = UIColor.gray.cgColor
                self.layer.cornerRadius = AdaptSize_ty(10)
            } else {
                self.layer.borderWidth  = 0
                self.layer.borderColor  = UIColor.clear.cgColor
                self.layer.cornerRadius = 0
                self.borderStyle        = .none
            }
        }
    }
    /// 显示右边空白视图（右边边距）
    public var showRightView_ty: Bool {
        willSet {
            if newValue {
                let _rightView = TYView_ty(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize_ty(15), height: AdaptSize_ty(1))))
                _rightView.backgroundColor = UIColor.clear
                self.rightView     = _rightView
                self.rightViewMode = .always
            } else {
                self.rightView     = nil
                self.rightViewMode = .never
            }
        }
    }
    
    public init(type: TYTextFieldType_ty) {
        self.type_ty          = type
        self.showLeftView_ty  = true
        self.showRightView_ty = true
        self.showBorder_ty    = false
        super.init(frame: .zero)
        self.bindProperty_ty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func bindProperty_ty() {
        self.delegate = self
        self.addTarget(self, action: #selector(editingAction_ty), for: .editingChanged)
    }
    
    // MARK: ==== Event ====
    @objc private func editingAction_ty() {
        self.editingBlock_ty?(self.text ?? "")
    }
    
    public func setPosition_ty(offset: Int) {
        // 先移到文首
        let begin = self.beginningOfDocument
        guard let start = self.position(from: begin, offset: 0) else { return }
        let startRange  = self.textRange(from: start, to: start)
        self.selectedTextRange = startRange
        // 移动到正确位置
        guard let selectedRange = self.selectedTextRange else { return }
        var currentOffset = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        currentOffset += offset
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: currentOffset) else { return }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
    
    public func getPosition_ty() -> Int {
        guard let range = self.selectedTextRange else {
            return self.text?.count ?? 0
        }
        let index = self.offset(from: self.beginningOfDocument, to: range.start)
        return index
    }
    
    // MARK: ==== UITextFieldDelegate ====
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, string.isNotEmpty_ty else { return true }
        // 长度判断
        if(currentText.utf16.count - range.length + string.utf16.count) > maxCount_ty {
            textField.text = currentText.substring_ty(fromIndex: 0, toIndex: maxCount_ty)
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.editFinishedBlock_ty?(text ?? "")
    }
}
