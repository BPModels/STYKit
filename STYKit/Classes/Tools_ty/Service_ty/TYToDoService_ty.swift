//
//  TYToDoService_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/13.
//

import Foundation

/// 全局待办事项控制器
/// 支持移除功能
@objc
public class TYToDoService_ty: NSObject {
    
    @objc
    static public let share_ty = TYToDoService_ty()
    
    /// 任务队列（任务类型， 任务事件， 延迟时间， 是否正在执行）
    @objc
    private var todoList_ty: [TYTodoModel_ty] = []
    @objc
    private var timer_ty: Timer?
    private var interval_ty: TimeInterval = 0.3
    
    /// 事项类型
    @objc
    public enum TYTodoType_ty: Int {
        case normal = 0
    }
    
    class TYTodoModel_ty: NSObject {
        var type_ty: TYTodoType_ty = .normal
        var eventBlock_ty: (()->Void)?
        var delayTime_ty: TimeInterval = 0
        var isRun_ty: Bool = false
        
        public override init() {
            super.init()
        }
    }
    
    // MARK: ==== Event ====
    
    /// 添加事件
    /// - Parameters:
    ///   - type: 事件类型
    ///   - eventBlock: 事件
    ///   - delayTime: 延迟时间
    @objc
    public func addEvent(type: TYTodoType_ty, eventBlock: (()->Void)?, delayTime: TimeInterval) {
        let model = TYTodoModel_ty()
        model.type_ty       = type
        model.eventBlock_ty = eventBlock
        model.delayTime_ty  = delayTime
        self.todoList_ty.append(model)
        if self.timer_ty == nil {
            self.timer_ty = Timer(timeInterval: self.interval_ty, target: self, selector: #selector(peeler), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer_ty!, forMode: .common)
            self.timer_ty?.fire()
        }
    }
    
    /// 移除事件
    /// - Parameter type: 事件类型
    @objc
    public func removeEvent(type: TYTodoType_ty) {
        for (index, model) in self.todoList_ty.enumerated() {
            if model.type_ty == type, index < self.todoList_ty.count {
                self.todoList_ty.remove(at: index)
                break
            }
        }
    }
    
    // TODO: ==== Event ====
    
    @objc
    private func peeler() {
        for (index, model) in self.todoList_ty.enumerated() {
            model.delayTime_ty -= self.interval_ty
            if model.delayTime_ty <= 0 && !model.isRun_ty {
                model.isRun_ty = true
                model.eventBlock_ty?()
                if index < self.todoList_ty.count {
                    self.todoList_ty.remove(at: index)
                }
                if self.todoList_ty.isEmpty {
                    self.timer_ty?.invalidate()
                    self.timer_ty = nil
                }
            }
        }
    }
}
