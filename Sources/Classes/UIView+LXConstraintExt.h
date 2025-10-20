//
//  UIView.h
//  TestYS
//
//  Created by Mac-Mini on 2025/8/11.
//


//
//  UIView+LXConstraintExt.h
//  TestYS
//
//  Created by Mac-Mini on 2025/8/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LXConstraintExt)

- (void)lx_makeConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block;
- (void)lx_updateConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block;
- (void)lx_removeAllConstraints;
- (void)lx_remakeConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block;

@end

NS_ASSUME_NONNULL_END
