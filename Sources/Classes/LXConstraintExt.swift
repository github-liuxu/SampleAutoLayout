//
//  LXConstraintExt.swift
//  TestYS
//
//  Created by Mac-Mini on 2025/8/8.
//

import Foundation
import UIKit

private let lx_ConstraintsKeyPointer = UnsafeRawPointer(bitPattern: "lx_Constraints".hashValue)!
extension UIView {
    
    func lx_makeConstraints(_ constraints: ((_ make: UIView) -> [NSLayoutConstraint])) {
        translatesAutoresizingMaskIntoConstraints = false
        let _constraints = constraints(self)
        NSLayoutConstraint.activate(_constraints)
        if var originConstraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer) as? [NSLayoutConstraint] {
            originConstraints.append(contentsOf: _constraints)
        } else {
            objc_setAssociatedObject(self, lx_ConstraintsKeyPointer, _constraints, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func lx_updateConstraints(_ constraints: ((_ make: UIView) -> [NSLayoutConstraint])) {
        let _constraints = constraints(self)
        if var existingConstraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer) as? [NSLayoutConstraint] {
            var toRemove: [NSLayoutConstraint] = []
            for newConstraint in _constraints {
                if let matchIndex = existingConstraints.firstIndex(where: { old in
                    return old.firstItem as? UIView == newConstraint.firstItem as? UIView &&
                           old.firstAttribute == newConstraint.firstAttribute
                }) {
                    toRemove.append(existingConstraints[matchIndex])
                    existingConstraints.remove(at: matchIndex)
                }
            }
            NSLayoutConstraint.deactivate(toRemove)
            NSLayoutConstraint.activate(_constraints)
            existingConstraints.append(contentsOf: _constraints)
            objc_setAssociatedObject(self, lx_ConstraintsKeyPointer, existingConstraints, .OBJC_ASSOCIATION_RETAIN)
        } else {
            lx_makeConstraints(constraints)
        }
    }
    
    func lx_removeAllConstraints() {
        if let constraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer) as? [NSLayoutConstraint] {
            NSLayoutConstraint.deactivate(constraints)
            objc_setAssociatedObject(self, lx_ConstraintsKeyPointer, nil, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func lx_remakeConstraints(_ constraints: ((_ make: UIView) -> [NSLayoutConstraint])) {
        lx_removeAllConstraints()
        lx_makeConstraints(constraints)
    }
}
