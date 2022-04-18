//
//  TYAlertViewOneButton.swift
//  STYKit
//
//  Created by apple on 2022/4/11.
//

import Foundation

public class KFAlertViewOneButton_ty: TYBaseAlertView_ty {
    
    private var partitionContentLineView_ty: TYView_ty = {
        let view_ty = TYView_ty()
        view_ty.backgroundColor = UIColor.gray4_ty
        return view_ty
    }()

    init(title_ty: String?, description_ty: String, buttonName_ty: String, closure_ty: (() -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel_ty.text       = title_ty
        self.descriptionLabel_ty.text = description_ty
        self.rightActionBlock_ty      = closure_ty
        self.rightButton_ty.setTitle(buttonName_ty, for: .normal)
        self.createSubviews_ty()
        self.bindProperty_ty()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func createSubviews_ty() {
        super.createSubviews_ty()
        mainView_ty.addSubview(titleLabel_ty)
        mainView_ty.addSubview(descriptionLabel_ty)
        mainView_ty.addSubview(rightButton_ty)
        mainView_ty.addSubview(partitionContentLineView_ty)
        // 是否显示标题
        if let title_ty = titleLabel_ty.text, title_ty.isNotEmpty_ty {
            titleLabel_ty.snp.makeConstraints { (make_ty) in
                make_ty.top.equalToSuperview().offset(topPadding_ty)
                make_ty.left.equalToSuperview().offset(leftPadding_ty)
                make_ty.right.equalToSuperview().offset(-rightPadding_ty)
                make_ty.height.equalTo(titleHeight_ty)
            }
            descriptionLabel_ty.snp.makeConstraints { (make_ty) in
                make_ty.top.equalTo(titleLabel_ty.snp.bottom).offset(defaultSpace_ty)
                make_ty.left.right.equalTo(titleLabel_ty)
                make_ty.height.equalTo(descriptionHeight_ty)
            }
            mainViewHeight_ty += topPadding_ty + titleHeight_ty + defaultSpace_ty + descriptionHeight_ty
        } else {
            descriptionLabel_ty.snp.makeConstraints { (make_ty) in
                make_ty.top.equalToSuperview().offset(topPadding_ty)
                make_ty.left.equalToSuperview().offset(leftPadding_ty)
                make_ty.right.equalTo(-rightPadding_ty)
                make_ty.height.equalTo(descriptionHeight_ty)
            }
            mainViewHeight_ty += topPadding_ty + descriptionHeight_ty
        }
        partitionContentLineView_ty.snp.makeConstraints { (make_ty) in
            make_ty.left.right.top.equalTo(rightButton_ty)
            make_ty.height.equalTo(AdaptSize_ty(0.6))
        }
        rightButton_ty.snp.makeConstraints { (make_ty) in
            make_ty.top.equalTo(descriptionLabel_ty.snp.bottom).offset(defaultSpace_ty)
            make_ty.left.right.equalToSuperview()
            make_ty.height.equalTo(closeBtnSize_ty.height)
        }
        mainViewHeight_ty += defaultSpace_ty + closeBtnSize_ty.height

        mainView_ty.snp.makeConstraints { (make_ty) in
            make_ty.center.equalToSuperview()
            make_ty.width.equalTo(mainViewWidth_ty)
            make_ty.height.equalTo(mainViewHeight_ty)
        }
    }
    
    public override func bindProperty_ty() {
        super.bindProperty_ty()
        self.backgroundView_ty.isUserInteractionEnabled = false
    }
}
