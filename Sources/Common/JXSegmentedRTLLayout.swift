//
//  JXSegmentedRTLLayout.swift
//  JXSegmentedView
//
//  Created by blue on 2020/6/18.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

/// 分段视图、Cell 和列表容器的全局排版方向入口。
public enum JXSegmentedLayoutDirection {
    /// 返回是否使用 RTL 布局；nil 时按 UIView.appearance().semanticContentAttribute 判断。
    /// 在主线程、创建分段视图和列表容器之前设置；每次判断方向时同步调用，不缓存结果。
    public static var isRTLProvider: (() -> Bool)?
}

public protocol JXSegmentedViewRTLCompatible: class {
    func segmentedViewShouldRTLLayout() -> Bool
    func segmentedView(horizontalFlipForView view: UIView?)
}

public extension JXSegmentedViewRTLCompatible {
    
    /// 根据全局布局方向提供闭包或系统布局方式判断是否需要 RTL 布局。
    /// - Returns: 当前布局方向为从右到左时返回 true。
    func segmentedViewShouldRTLLayout() -> Bool {
        if let provider = JXSegmentedLayoutDirection.isRTLProvider {
            return provider()
        }
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    /// 在RTL布局下水平翻转当前视图
    /// - Parameter view: 需要翻转的视图
    func segmentedView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

class JXSegmentedRTLCollectionCell: UICollectionViewCell, JXSegmentedViewRTLCompatible {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: self)
            segmentedView(horizontalFlipForView: contentView)
        }
    }
    
}
