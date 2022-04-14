//
//  Extension+UIScrollView_ty.swift
//  STYKit
//
//  Created by apple on 2022/4/14.
//

import Foundation

public enum BPRefreshStatus: Int, Equatable {
    
    /// 顶部默认状态
    case headerNormal  = 10
    /// 下拉滑动中
    case headerPulling = 11
    /// 下拉滑动超过阈值
    case headerPullMax = 12
    /// 下拉刷新中
    case headerLoading = 13
    /// 下拉刷新结束
    case headerEnd     = 15
    
    /// 底部默认状态
    case footerNormal  = 20
    /// 上拉滑动中
    case footerPulling = 21
    /// 上拉滑动超过阈值
    case footerPullMax = 22
    /// 上拉加载中
    case footerLoading = 23
    /// 上拉加载结束
    case footerEnd     = 24
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
}

/// 对外暴露的回调
@objc
public protocol BPRefreshProtocol: NSObjectProtocol {
    // -------- Header ---------
    /// 下拉Header中
    /// - Parameter scrollView: scrollView
    @objc optional func pullingHeader(scrollView: UIScrollView)
    /// 下拉Header超过最大长度
    /// - Parameter scrollView: scrollView
    @objc optional func pullMaxHeader(scrollView: UIScrollView)
    /// 刷新中
    /// - Parameter scrollView: scrollView
    @objc optional func loadingHeader(scrollView: UIScrollView)
    /// 恢复头部视图
    /// - Parameter scrollView: scrollView
    @objc optional func recoverHeaderView(scrollView: UIScrollView)
    // -------- Footer ---------
    /// 上拉Footer中
    /// - Parameter scrollView: scrollView
    @objc optional func pullingFooter(scrollView: UIScrollView)
    /// 上拉Footer超过最大长度
    /// - Parameter scrollView: scrollView
    @objc optional func pullMaxFooter(scrollView: UIScrollView)
    /// 加载中
    /// - Parameter scrollView: scrollView
    @objc optional func loadingFooter(scrollView: UIScrollView)
    /// 恢复底部视图
    /// - Parameter scrollView: scrollView
    @objc optional func recoverFooterView(scrollView: UIScrollView)
}

private struct AssociatedKeys {
    static var refreshHeaderEnable = "kRefreshHeaderEnable"
    static var refreshFooterEnable = "kRefreshFooterEnable"
    static var headerView          = "kHeaderView"
    static var footerView          = "kFooterView"
    static var refreshHeaderBlock  = "kRefreshHeaderBlock"
    static var refreshFooterBlock  = "kRefreshFooterBlock"
    static var refreshDelegate     = "kRefreshDelegate"
    static var observerEnable      = "kObserverEnable"
    static var refreshStatus       = "kRefreshStatus"
    static var page                = "kPage"
    static var pageSize            = "kPageSize"
    static var rows                = "krows"
}

public extension UIScrollView {
    
    /// 滑动代理
    weak var refreshDelegate: BPRefreshProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshDelegate) as? BPRefreshProtocol
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshDelegate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 分页
    var page: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.page) as? Int ?? 1
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.page, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    /// 一页数量
    var pageSize: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pageSize) as? Int ?? 20
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pageSize, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 缓存刷新前的数量
    private var rows: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.rows) as? Int ?? 0
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.rows, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 刷新状态
    private var refreshStatus: BPRefreshStatus? {
        get {
            guard let raw = objc_getAssociatedObject(self, &AssociatedKeys.refreshStatus) as? Int else {
                return nil
            }
            return BPRefreshStatus(rawValue: raw)
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshStatus, newValue?.rawValue ?? 0, .OBJC_ASSOCIATION_ASSIGN)
            guard let status = newValue else { return }
            switch status {
            case .headerNormal:
                self.headerView?.setStatus(status: status)
                self.refreshDelegate?.recoverHeaderView?(scrollView: self)
            case .headerPulling:
                self.headerView?.setStatus(status: status)
                self.refreshDelegate?.pullingHeader?(scrollView: self)
            case .headerPullMax:
                self.headerView?.setStatus(status: status)
                self.refreshDelegate?.pullMaxHeader?(scrollView: self)
            case .headerLoading:
                self.headerView?.setStatus(status: status)
                self.refreshBefore(isHeader: true)
                self.refreshDelegate?.loadingHeader?(scrollView: self)
                (self.refreshHeaderBlock ?? nil)?{
                    // 完成请求后结束刷新
                    self.refreshCompletion(isHeader: true)
                }
            case .headerEnd:
                self.headerView?.setStatus(status: status)
                self.refreshDelegate?.recoverHeaderView?(scrollView: self)
                self.refreshCompletion(isHeader: true)
                
            case .footerNormal:
                self.footerView?.setStatus(status: status)
                self.refreshDelegate?.recoverFooterView?(scrollView: self)
            case .footerPulling:
                self.footerView?.setStatus(status: status)
                self.refreshDelegate?.pullingFooter?(scrollView: self)
            case .footerPullMax:
                self.footerView?.setStatus(status: status)
                self.refreshDelegate?.pullMaxFooter?(scrollView: self)
            case .footerLoading:
                self.footerView?.setStatus(status: status)
                self.refreshBefore(isHeader: false)
                self.refreshDelegate?.loadingFooter?(scrollView: self)
                (self.refreshFooterBlock ?? nil)?{
                    // 完成请求后结束刷新
                    self.refreshCompletion(isHeader: false)
                }
            case .footerEnd:
                self.footerView?.setStatus(status: status)
                self.refreshDelegate?.recoverFooterView?(scrollView: self)
                self.refreshCompletion(isHeader: false)
            }
        }
    }
    
    /// 是否开启滑动监听
    private var observerEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.observerEnable) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.observerEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// 是否开启下拉刷新
    private var refreshHeaderEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshHeaderEnable) as? Bool ?? false
        }
        
        set {
            if newValue {
                if !refreshHeaderEnable {
                    // 开启KVO监听
                    self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                }
            } else {
                // 取消KVO监听
                self.refreshCompletion(isHeader: true)
                self.removeObserver(self, forKeyPath: "contentOffset")
            }
            objc_setAssociatedObject(self, &AssociatedKeys.refreshHeaderEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 是否开启上拉加载更多
    private var refreshFooterEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshFooterEnable) as? Bool ?? false
        }
        
        set {
            if newValue {
                if !refreshFooterEnable {
                    // 开启KVO监听
                    self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
                }
            } else {
                // 取消KVO监听
                self.refreshCompletion(isHeader: false)
                self.removeObserver(self, forKeyPath: "contentOffset")
            }
            objc_setAssociatedObject(self, &AssociatedKeys.refreshFooterEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 下拉刷新闭包
    private var refreshHeaderBlock: (((DefaultBlock_ty?)->Void)?) {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshHeaderBlock) as? ((DefaultBlock_ty?)->Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshHeaderBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 上拉加载闭包
    private var refreshFooterBlock: ((DefaultBlock_ty?)->Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshFooterBlock) as? ((DefaultBlock_ty?)->Void)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshFooterBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 设置下拉刷新
    /// - Parameter block: 刷新闭包
    func setRefreshHeaderEnable(block: ((DefaultBlock_ty?)->Void)?) {
        self.refreshHeaderBlock  = block
        self.refreshHeaderEnable = true
    }
    
    /// 设置上拉加载更多
    /// - Parameter block: 加载闭包
    func setRefreshFooterEnable(block: ((DefaultBlock_ty?)->Void)?) {
        self.refreshFooterBlock  = block
        self.refreshFooterEnable = true
    }
    
    /// 加载前
    /// - Parameter isHeader: 是否下拉刷新
    @objc
    private func refreshBefore(isHeader: Bool) {
        self.rows = self.getCellAmount()
    }
    
    /// 加载完成
    /// - Parameter isHeader: 是否下拉刷新
    private func refreshCompletion(isHeader: Bool) {
        self.adjustPage(isHeader: isHeader)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.contentInset  = .zero
            self.refreshStatus = .headerNormal
            self.refreshStatus = .footerNormal
        }
    }
    
    /// 对比之前缓存的数量，是否有增加
    /// - Parameter isHeader: 是否是下拉刷新
    private func adjustPage(isHeader: Bool) {
        if isHeader {
            self.page = 1
        } else {
            // 对比之前的大小
            let _rows = self.getCellAmount()
            if _rows > self.rows {
                self.page += 1
            } else if _rows < self.rows {
                self.page = 1
            }
        }
    }
    
    /// 刷新头部视图
    private var headerView: TYRefreshHeaderView_ty? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.headerView) as? TYRefreshHeaderView_ty
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.headerView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 加载跟多底部视图
    private var footerView: TYRefreshFooterView_ty? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footerView) as? TYRefreshFooterView_ty
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.footerView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 滑动结束，供外部调用
    func scrollEnd() {
        if self.refreshStatus ?? .footerEnd > BPRefreshStatus.footerNormal {
            self.refreshStatus = .footerEnd
        } else {
            self.refreshStatus = .headerEnd
        }
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        // 设置默认最大拖拽长度
        let pullHeaderMaxSize = AdaptSize_ty(60)
        let pullFooterMaxSize = AdaptSize_ty(60)
        
        var offsetY = self.contentOffset.y
        
        if self.isDragging {
            self.observerEnable = true
            if offsetY < 0 && self.refreshHeaderEnable {
                if offsetY > -pullHeaderMaxSize {
                    // 滑动中
                    self.refreshStatus = .headerPulling
                } else {
                    // 超过最大长度
                    self.refreshStatus = .headerPullMax
                }
                // 添加头部视图
                if self.headerView == nil {
                    self.createHeaderView()
                }
            } else {
                DispatchQueue.once_ty(token: "kRefreshBefore") { [weak self] in
                    self?.refreshBefore(isHeader: false)
                }
                guard rows > 0 else { return }
                offsetY = self.height_ty + offsetY - self.contentSize.height
                // 忽略列表中滑动
                if offsetY > 0 && self.refreshFooterEnable {
                    if self.footerView == nil {
                        self.createFooterView()
                    } else {
                        self.updateFooterView()
                    }
                    if offsetY > pullFooterMaxSize {
                        // 超过最大长度
                        self.refreshStatus = .footerPullMax
                    } else  {
                        // 滑动中
                        self.refreshStatus = .footerPulling
                    }
                }
            }
        } else {
            // 防止多次触发回调
            guard self.observerEnable else { return }
            if offsetY < 0 && self.refreshHeaderEnable  {
                // 下拉
                if self.refreshStatus == .some(.headerPullMax) {
                    // 触发刷新
                    self.refreshStatus = .headerLoading
                    // 显示刷新中状态
                    if offsetY < pullHeaderMaxSize {
                        self.contentInset = UIEdgeInsets(top: self.headerView?.height_ty ?? 0, left: 0, bottom: 0, right: 0)
                    }
                } else if self.refreshStatus != .headerLoading {
                    // 恢复默认状态
                    self.refreshStatus = .headerNormal
                }
            } else {
                guard rows > 0 else { return }
                // 上拉
                offsetY = self.height_ty + offsetY - self.contentSize.height
                // 忽略列表中滑动
                if offsetY > 0 && self.refreshFooterEnable {
                    if self.refreshStatus == .some(.footerPullMax) {
                        // 触发加载更多
                        self.refreshStatus = .footerLoading
                        // 显示刷新中状态
                        if offsetY > pullFooterMaxSize {
                            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.footerView?.height_ty ?? 0, right: 0)
                        }
                    } else if self.refreshStatus != .footerLoading {
                        // 恢复默认状态
                        self.refreshStatus = .footerNormal
                    }
                }
            }
            self.observerEnable = false
        }
        
    }
    
    // MARK: ==== Tools ====
    private func createHeaderView() {
        self.headerView = TYRefreshHeaderView_ty()
        self.addSubview(headerView!)
        headerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
            make.height.equalTo(AdaptSize_ty(50))
            make.width.equalToSuperview()
        })
    }
    
    private func createFooterView() {
        self.footerView = TYRefreshFooterView_ty()
        self.addSubview(footerView!)
        footerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(self.contentSize.height)
            make.height.equalTo(AdaptSize_ty(50))
            make.width.equalToSuperview()
        })
    }
    
    private func updateFooterView() {
        footerView?.snp.updateConstraints({ (make) in
            make.top.equalToSuperview().offset(self.contentSize.height)
        })
    }
    
    private func getCellAmount() -> Int {
        var amount = 0
        if let tableView = self as? UITableView {
            let section = tableView.numberOfSections
            for section in 0..<section {
                amount += tableView.numberOfRows(inSection: section)
            }
        } else if let collectionView = self as? UICollectionView {
            let section = collectionView.numberOfSections
            for section in 0..<section {
                amount += collectionView.numberOfItems(inSection: section)
            }
        }
        return amount
    }
    
}
