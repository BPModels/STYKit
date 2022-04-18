//
//  Extension+UIScrollView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

public enum BPRefreshStatus_ty: Int, Equatable {
    
    /// 顶部默认状态
    case headerNormal_ty  = 10
    /// 下拉滑动中
    case headerPulling_ty = 11
    /// 下拉滑动超过阈值
    case headerPullMax_ty = 12
    /// 下拉刷新中
    case headerLoading_ty = 13
    /// 下拉刷新结束
    case headerEnd_ty     = 15
    
    /// 底部默认状态
    case footerNormal_ty  = 20
    /// 上拉滑动中
    case footerPulling_ty = 21
    /// 上拉滑动超过阈值
    case footerPullMax_ty = 22
    /// 上拉加载中
    case footerLoading_ty = 23
    /// 上拉加载结束
    case footerEnd_ty     = 24
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

/// 对外暴露的回调
@objc
public protocol BPRefreshProtocol_ty: NSObjectProtocol {
    // -------- Header ---------
    /// 下拉Header中
    /// - Parameter scrollView: scrollView_ty
    @objc optional func pullingHeader_ty(scrollView_ty: UIScrollView)
    /// 下拉Header超过最大长度
    /// - Parameter scrollView: scrollView_ty
    @objc optional func pullMaxHeader_ty(scrollView_ty: UIScrollView)
    /// 刷新中
    /// - Parameter scrollView: scrollView_ty
    @objc optional func loadingHeader_ty(scrollView_ty: UIScrollView)
    /// 恢复头部视图
    /// - Parameter scrollView: scrollView_ty
    @objc optional func recoverHeaderView_ty(scrollView_ty: UIScrollView)
    // -------- Footer ---------
    /// 上拉Footer中
    /// - Parameter scrollView: scrollView_ty
    @objc optional func pullingFooter_ty(scrollView_ty: UIScrollView)
    /// 上拉Footer超过最大长度
    /// - Parameter scrollView: scrollView_ty
    @objc optional func pullMaxFooter_ty(scrollView_ty: UIScrollView)
    /// 加载中
    /// - Parameter scrollView: scrollView_ty
    @objc optional func loadingFooter_ty(scrollView_ty: UIScrollView)
    /// 恢复底部视图
    /// - Parameter scrollView: scrollView_ty
    @objc optional func recoverFooterView_ty(scrollView_ty: UIScrollView)
}

private struct AssociatedKeys_ty {
    static var refreshHeaderEnable_ty = "kRefreshHeaderEnable_ty"
    static var refreshFooterEnable_ty = "kRefreshFooterEnable_ty"
    static var headerView_ty          = "kHeaderView_ty"
    static var footerView_ty          = "kFooterView_ty"
    static var refreshHeaderBlock_ty  = "kRefreshHeaderBlock_ty"
    static var refreshFooterBlock_ty  = "kRefreshFooterBlock_ty"
    static var refreshDelegate_ty     = "kRefreshDelegate_ty"
    static var observerEnable_ty      = "kObserverEnable_ty"
    static var refreshStatus_ty       = "kRefreshStatus_ty"
    static var page_ty                = "kPage_ty"
    static var pageSize_ty            = "kPageSize_ty"
    static var rows_ty                = "krows_ty"
}

public extension UIScrollView {
    
    /// 滑动代理
    weak var refreshDelegate_ty: BPRefreshProtocol_ty? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshDelegate_ty) as? BPRefreshProtocol_ty
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshDelegate_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 分页
    var page_ty: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.page_ty) as? Int ?? 1
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.page_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    /// 一页数量
    var pageSize_ty: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.pageSize_ty) as? Int ?? 20
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.pageSize_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 缓存刷新前的数量
    private var rows_ty: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.rows_ty) as? Int ?? 0
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.rows_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 刷新状态
    private var refreshStatus_ty: BPRefreshStatus_ty? {
        get {
            guard let raw_ty = objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshStatus_ty) as? Int else {
                return nil
            }
            return BPRefreshStatus_ty(rawValue: raw_ty)
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshStatus_ty, newValue_ty?.rawValue ?? 0, .OBJC_ASSOCIATION_ASSIGN)
            guard let status_ty = newValue_ty else { return }
            switch status_ty {
            case .headerNormal_ty:
                self.headerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.recoverHeaderView_ty?(scrollView_ty: self)
            case .headerPulling_ty:
                self.headerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.pullingHeader_ty?(scrollView_ty: self)
            case .headerPullMax_ty:
                self.headerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.pullMaxHeader_ty?(scrollView_ty: self)
            case .headerLoading_ty:
                self.headerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshBefore_ty(isHeader_ty: true)
                self.refreshDelegate_ty?.loadingHeader_ty?(scrollView_ty: self)
                (self.refreshHeaderBlock_ty ?? nil)?{
                    // 完成请求后结束刷新
                    self.refreshCompletion_ty(isHeader_ty: true)
                }
            case .headerEnd_ty:
                self.headerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.recoverHeaderView_ty?(scrollView_ty: self)
                self.refreshCompletion_ty(isHeader_ty: true)
                
            case .footerNormal_ty:
                self.footerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.recoverFooterView_ty?(scrollView_ty: self)
            case .footerPulling_ty:
                self.footerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.pullingFooter_ty?(scrollView_ty: self)
            case .footerPullMax_ty:
                self.footerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.pullMaxFooter_ty?(scrollView_ty: self)
            case .footerLoading_ty:
                self.footerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshBefore_ty(isHeader_ty: false)
                self.refreshDelegate_ty?.loadingFooter_ty?(scrollView_ty: self)
                (self.refreshFooterBlock_ty ?? nil)?{
                    // 完成请求后结束刷新
                    self.refreshCompletion_ty(isHeader_ty: false)
                }
            case .footerEnd_ty:
                self.footerView_ty?.setStatus_ty(status_ty: status_ty)
                self.refreshDelegate_ty?.recoverFooterView_ty?(scrollView_ty: self)
                self.refreshCompletion_ty(isHeader_ty: false)
            }
        }
    }
    
    /// 是否开启滑动监听
    private var observerEnable_ty: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.observerEnable_ty) as? Bool ?? false
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.observerEnable_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// 是否开启下拉刷新
    private var refreshHeaderEnable_ty: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshHeaderEnable_ty) as? Bool ?? false
        }
        
        set(newValue_ty) {
            if newValue_ty {
                if !refreshHeaderEnable_ty {
                    // 开启KVO监听
                    self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                }
            } else {
                // 取消KVO监听
                self.refreshCompletion_ty(isHeader_ty: true)
                self.removeObserver(self, forKeyPath: "contentOffset")
            }
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshHeaderEnable_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 是否开启上拉加载更多
    private var refreshFooterEnable_ty: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshFooterEnable_ty) as? Bool ?? false
        }
        
        set(newValue_ty) {
            if newValue_ty {
                if !refreshFooterEnable_ty {
                    // 开启KVO监听
                    self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                }
            } else {
                // 取消KVO监听
                self.refreshCompletion_ty(isHeader_ty: false)
                self.removeObserver(self, forKeyPath: "contentOffset")
            }
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshFooterEnable_ty, newValue_ty, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 下拉刷新闭包
    private var refreshHeaderBlock_ty: (((DefaultBlock_ty?)->Void)?) {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshHeaderBlock_ty) as? ((DefaultBlock_ty?)->Void)
        }
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshHeaderBlock_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 上拉加载闭包
    private var refreshFooterBlock_ty: ((DefaultBlock_ty?)->Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.refreshFooterBlock_ty) as? ((DefaultBlock_ty?)->Void)
        }
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.refreshFooterBlock_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置下拉刷新
    /// - Parameter block: 刷新闭包
    func setRefreshHeaderEnable_ty(block_ty: ((DefaultBlock_ty?)->Void)?) {
        self.refreshHeaderBlock_ty  = block_ty
        self.refreshHeaderEnable_ty = true
    }
    
    /// 设置上拉加载更多
    /// - Parameter block: 加载闭包
    func setRefreshFooterEnable_ty(block_ty: ((DefaultBlock_ty?)->Void)?) {
        self.refreshFooterBlock_ty  = block_ty
        self.refreshFooterEnable_ty = true
    }
    
    /// 加载前
    /// - Parameter isHeader: 是否下拉刷新
    @objc
    private func refreshBefore_ty(isHeader_ty: Bool) {
        self.rows_ty = self.getCellAmount_ty()
    }
    
    /// 加载完成
    /// - Parameter isHeader: 是否下拉刷新
    private func refreshCompletion_ty(isHeader_ty: Bool) {
        self.adjustPage_ty(isHeader_ty: isHeader_ty)
        DispatchQueue.main.async { [weak self] in
            guard let self_ty = self else { return }
            self_ty.contentInset     = .zero
            self_ty.refreshStatus_ty = .headerNormal_ty
            self_ty.refreshStatus_ty = .footerNormal_ty
        }
    }
    
    /// 对比之前缓存的数量，是否有增加
    /// - Parameter isHeader_ty: 是否是下拉刷新
    private func adjustPage_ty(isHeader_ty: Bool) {
        if isHeader_ty {
            self.page_ty = 1
        } else {
            // 对比之前的大小
            let _rows_ty = self.getCellAmount_ty()
            if _rows_ty > self.rows_ty {
                self.page_ty += 1
            } else if _rows_ty < self.rows_ty {
                self.page_ty = 1
            }
        }
    }
    
    /// 刷新头部视图
    private var headerView_ty: TYRefreshHeaderView_ty? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.headerView_ty) as? TYRefreshHeaderView_ty
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.headerView_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 加载跟多底部视图
    private var footerView_ty: TYRefreshFooterView_ty? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys_ty.footerView_ty) as? TYRefreshFooterView_ty
        }
        
        set(newValue_ty) {
            objc_setAssociatedObject(self, &AssociatedKeys_ty.footerView_ty, newValue_ty, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 滑动结束，供外部调用
    func scrollEnd_ty() {
        if self.refreshStatus_ty ?? .footerEnd_ty > BPRefreshStatus_ty.footerNormal_ty {
            self.refreshStatus_ty = .footerEnd_ty
        } else {
            self.refreshStatus_ty = .headerEnd_ty
        }
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        // 设置默认最大拖拽长度
        let pullHeaderMaxSize_ty = AdaptSize_ty(60)
        let pullFooterMaxSize_ty = AdaptSize_ty(60)
        
        var offsetY_ty = self.contentOffset.y
        
        if self.isDragging {
            self.observerEnable_ty = true
            if offsetY_ty < 0 && self.refreshHeaderEnable_ty {
                if offsetY_ty > -pullHeaderMaxSize_ty {
                    // 滑动中
                    self.refreshStatus_ty = .headerPulling_ty
                } else {
                    // 超过最大长度
                    self.refreshStatus_ty = .headerPullMax_ty
                }
                // 添加头部视图
                if self.headerView_ty == nil {
                    self.createHeaderView_ty()
                }
            } else {
                DispatchQueue.once_ty(token_ty: "kRefreshBefore_ty") { [weak self] in
                    self?.refreshBefore_ty(isHeader_ty: false)
                }
                guard rows_ty > 0 else { return }
                offsetY_ty = self.height_ty + offsetY_ty - self.contentSize.height
                // 忽略列表中滑动
                if offsetY_ty > 0 && self.refreshFooterEnable_ty {
                    if self.footerView_ty == nil {
                        self.createFooterView_ty()
                    } else {
                        self.updateFooterView_ty()
                    }
                    if offsetY_ty > pullFooterMaxSize_ty {
                        // 超过最大长度
                        self.refreshStatus_ty = .footerPullMax_ty
                    } else  {
                        // 滑动中
                        self.refreshStatus_ty = .footerPulling_ty
                    }
                }
            }
        } else {
            // 防止多次触发回调
            guard self.observerEnable_ty else { return }
            if offsetY_ty < 0 && self.refreshHeaderEnable_ty {
                // 下拉
                if self.refreshStatus_ty == .some(.headerPullMax_ty) {
                    // 触发刷新
                    self.refreshStatus_ty = .headerLoading_ty
                    // 显示刷新中状态
                    if offsetY_ty < pullHeaderMaxSize_ty {
                        self.contentInset = UIEdgeInsets(top: self.headerView_ty?.height_ty ?? 0, left: 0, bottom: 0, right: 0)
                    }
                } else if self.refreshStatus_ty != .headerLoading_ty {
                    // 恢复默认状态
                    self.refreshStatus_ty = .headerNormal_ty
                }
            } else {
                guard rows_ty > 0 else { return }
                // 上拉
                offsetY_ty = self.height_ty + offsetY_ty - self.contentSize.height
                // 忽略列表中滑动
                if offsetY_ty > 0 && self.refreshFooterEnable_ty {
                    if self.refreshStatus_ty == .some(.footerPullMax_ty) {
                        // 触发加载更多
                        self.refreshStatus_ty = .footerLoading_ty
                        // 显示刷新中状态
                        if offsetY_ty > pullFooterMaxSize_ty {
                            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.footerView_ty?.height_ty ?? 0, right: 0)
                        }
                    } else if self.refreshStatus_ty != .footerLoading_ty {
                        // 恢复默认状态
                        self.refreshStatus_ty = .footerNormal_ty
                    }
                }
            }
            self.observerEnable_ty = false
        }
        
    }
    
    // MARK: ==== Tools ====
    private func createHeaderView_ty() {
        self.headerView_ty = TYRefreshHeaderView_ty()
        self.addSubview(headerView_ty!)
        headerView_ty?.snp.makeConstraints({ (make_ty) in
            make_ty.centerX.equalToSuperview()
            make_ty.bottom.equalTo(self.snp.top)
            make_ty.height.equalTo(AdaptSize_ty(50))
            make_ty.width.equalToSuperview()
        })
    }
    
    private func createFooterView_ty() {
        self.footerView_ty = TYRefreshFooterView_ty()
        self.addSubview(footerView_ty!)
        footerView_ty?.snp.makeConstraints({ (make_ty) in
            make_ty.centerX.equalToSuperview()
            make_ty.top.equalToSuperview().offset(self.contentSize.height)
            make_ty.height.equalTo(AdaptSize_ty(50))
            make_ty.width.equalToSuperview()
        })
    }
    
    private func updateFooterView_ty() {
        footerView_ty?.snp.updateConstraints({ (make_ty) in
            make_ty.top.equalToSuperview().offset(self.contentSize.height)
        })
    }
    
    private func getCellAmount_ty() -> Int {
        var amount_ty = 0
        if let tableView_ty = self as? UITableView {
            let sections_ty = tableView_ty.numberOfSections
            for section_ty in 0..<sections_ty {
                amount_ty += tableView_ty.numberOfRows(inSection: section_ty)
            }
        } else if let collectionView_ty = self as? UICollectionView {
            let sections_ty = collectionView_ty.numberOfSections
            for section_ty in 0..<sections_ty {
                amount_ty += collectionView_ty.numberOfItems(inSection: section_ty)
            }
        }
        return amount_ty
    }
    
}
