//
//  TYAlertViewTwoButton_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import UIKit

public class TYAlertViewTwoButton_ty: TYBaseAlertView_ty {
    
    public init(title_ty: String?, description_ty: String, leftBtnName_ty: String, leftBtnClosure_ty: (() -> Void)?, rightBtnName_ty: String, rightBtnClosure_ty: (() -> Void)?, isDestruct_ty: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct_ty            = isDestruct_ty
        self.titleLabel_ty.text       = title_ty
        self.descriptionLabel_ty.text = description_ty
        self.rightActionBlock_ty      = rightBtnClosure_ty
        self.leftActionBlock_ty       = leftBtnClosure_ty
        self.leftButton_ty.setTitle(leftBtnName_ty, for: .normal)
        self.rightButton_ty.setTitle(rightBtnName_ty, for: .normal)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    public init(title_ty: String?, description_ty: NSMutableAttributedString, leftBtnName_ty: String, leftBtnClosure_ty: (() -> Void)?, rightBtnName_ty: String, rightBtnClosure_ty: (() -> Void)?, isDestruct_ty: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct_ty                         = isDestruct_ty
        self.titleLabel_ty.text                    = title_ty
        self.descriptionLabel_ty.attributedText    = description_ty
        self.rightActionBlock_ty                   = rightBtnClosure_ty
        self.leftActionBlock_ty                    = leftBtnClosure_ty
        self.leftButton_ty.setTitle(leftBtnName_ty, for: .normal)
        self.rightButton_ty.setTitle(rightBtnName_ty, for: .normal)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews_ty() {
        super.createSubviews_ty()
        
        mainView_ty.addSubview(titleLabel_ty)
        mainView_ty.addSubview(contentScrollView_ty)
        contentScrollView_ty.addSubview(descriptionLabel_ty)
        mainView_ty.addSubview(leftButton_ty)
        mainView_ty.addSubview(rightButton_ty)
        
        titleLabel_ty.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding_ty)
            make.left.equalToSuperview().offset(leftPadding_ty)
            make.right.equalToSuperview().offset(-rightPadding_ty)
            make.height.equalTo(titleHeight_ty)
        }
        mainViewHeight_ty += topPadding_ty + titleHeight_ty
        let descriptionLabelW_ty = mainViewWidth_ty - leftPadding_ty - rightPadding_ty
        let descriptionLabelH_ty = descriptionLabel_ty.text?.textHeight_ty(font_ty: descriptionLabel_ty.font, width_ty: descriptionLabelW_ty) ?? 0
        descriptionLabel_ty.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: descriptionLabelW_ty, height: descriptionLabelH_ty))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(leftPadding_ty)
            make.right.equalToSuperview().offset(-rightPadding_ty)
        }
        contentScrollView_ty.contentSize = CGSize(width: descriptionLabelW_ty, height: descriptionLabelH_ty)
        contentScrollView_ty.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel_ty.snp.bottom).offset(defaultSpace_ty)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(rightButton_ty.snp.top).offset(-defaultSpace_ty)
        }
        if descriptionLabelH_ty > maxContentHeight_ty {
            mainViewHeight_ty += defaultSpace_ty + maxContentHeight_ty
        } else {
            mainViewHeight_ty += defaultSpace_ty + descriptionLabelH_ty
        }
        
        rightButton_ty.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize_ty(-30))
            make.size.equalTo(rightButton_ty.size_ty)
            make.bottom.equalToSuperview().offset(-bottomPadding_ty)
        }
        leftButton_ty.snp.makeConstraints { (make) in
            make.bottom.size.equalTo(rightButton_ty)
            make.left.equalToSuperview().offset(AdaptSize_ty(30))
        }
        mainViewHeight_ty += defaultSpace_ty + rightButton_ty.height_ty + bottomPadding_ty
        
        mainView_ty.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth_ty)
            make.height.equalTo(mainViewHeight_ty)
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundView_ty.isUserInteractionEnabled = false
    }
}
