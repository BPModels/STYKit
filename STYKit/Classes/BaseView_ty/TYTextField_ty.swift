//
//  TYTextField_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public enum TYTextFieldType_ty {
    case normal_ty
    case number_ty
    case password_ty
}

public class TYTextField_ty: UITextField, UITextFieldDelegate {
    
    public var type_ty: TYTextFieldType_ty
    public var maxCount_ty: Int = .max
    public var editingBlock_ty: StringBlock_ty?
    public var editFinishedBlock_ty: StringBlock_ty?
    
    /// 显示左边空白视图（左边边距）
    public var showLeftView_ty: Bool {
        willSet(newValue_ty) {
            if newValue_ty {
                let _leftView_ty = TYView_ty(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize_ty(15), height: AdaptSize_ty(1))))
                _leftView_ty.backgroundColor = UIColor.clear
                self.leftView     = _leftView_ty
                self.leftViewMode = .always
            } else {
                self.leftView     = nil
                self.leftViewMode = .never
            }
        }
    }
    /// 显示边框
    public var showBorder_ty: Bool = false {
        willSet(newValue_ty) {
            if newValue_ty {
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
        willSet(newValue_ty) {
            if newValue_ty {
                let _rightView_ty = TYView_ty(frame: CGRect(origin: .zero, size: CGSize(width: AdaptSize_ty(15), height: AdaptSize_ty(1))))
                _rightView_ty.backgroundColor = UIColor.clear
                self.rightView     = _rightView_ty
                self.rightViewMode = .always
            } else {
                self.rightView     = nil
                self.rightViewMode = .never
            }
        }
    }
    
    public init(type_ty: TYTextFieldType_ty = .normal_ty) {
        self.type_ty          = type_ty
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
    
    public func setPosition_ty(offset_ty: Int) {
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
    
    public func getPosition_ty() -> Int {
        guard let range_ty = self.selectedTextRange else {
            return self.text?.count ?? 0
        }
        let index_ty = self.offset(from: self.beginningOfDocument, to: range_ty.start)
        return index_ty
    }
    
    // MARK: ==== UITextFieldDelegate ====
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText_ty = textField.text, string.isNotEmpty_ty else { return true }
        // 长度判断
        if(currentText_ty.utf16.count - range.length + string.utf16.count) > maxCount_ty {
            textField.text = currentText_ty.substring_ty(fromIndex_ty: 0, toIndex_ty: maxCount_ty)
            return false
        } else {
            return true
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.editFinishedBlock_ty?(text ?? "")
    }
}
