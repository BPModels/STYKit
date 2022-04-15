//
//  TYTaskRequestDelegate_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation
import Alamofire

public protocol TYTaskRequestDelegate_ty {
    var request_ty: TYTaskRequestDelegate_ty { get }
    func cancel_ty()
}

public class TYRequestModel_ty {

    ///请求Request类型对象
    private var taskRequest_ty: Request?

    init(request: Request) {
        self.taskRequest_ty = request
    }
}

extension TYRequestModel_ty: TYTaskRequestDelegate_ty {

    public var request_ty: TYTaskRequestDelegate_ty {
        return self
    }

    public func cancel_ty() {
        guard let request = self.taskRequest_ty else {
            return
        }
        request.cancel()
    }
}
