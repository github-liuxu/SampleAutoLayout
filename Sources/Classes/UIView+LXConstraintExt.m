//
//  UIView.m
//  TestYS
//
//  Created by Mac-Mini on 2025/8/11.
//


//
//  UIView+LXConstraintExt.m
//  TestYS
//
//  Created by Mac-Mini on 2025/8/8.
//

#import "UIView+LXConstraintExt.h"
#import <objc/runtime.h>

static const void *lx_ConstraintsKeyPointer = &lx_ConstraintsKeyPointer;

@implementation UIView (LXConstraintExt)

- (void)lx_makeConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray<NSLayoutConstraint *> *constraints = block(self);
    [NSLayoutConstraint activateConstraints:constraints];
    
    NSMutableArray *originConstraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer);
    if (originConstraints) {
        [originConstraints addObjectsFromArray:constraints];
    } else {
        objc_setAssociatedObject(self, lx_ConstraintsKeyPointer,
                                 [constraints mutableCopy],
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)lx_updateConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block {
    NSMutableArray *existingConstraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer);
    NSArray<NSLayoutConstraint *> *constraints = block(self);
    if (existingConstraints) {
        NSMutableArray *toRemove = [NSMutableArray array];
        
        for (NSLayoutConstraint *newConstraint in constraints) {
            NSUInteger matchIndex = [existingConstraints indexOfObjectPassingTest:^BOOL(NSLayoutConstraint *oldConstraint, NSUInteger idx, BOOL *stop) {
                return oldConstraint.firstItem == newConstraint.firstItem &&
                oldConstraint.firstAttribute == newConstraint.firstAttribute;
            }];
            
            if (matchIndex != NSNotFound) {
                [toRemove addObject:existingConstraints[matchIndex]];
                [existingConstraints removeObjectAtIndex:matchIndex];
            }
        }
        
        [NSLayoutConstraint deactivateConstraints:toRemove];
        [NSLayoutConstraint activateConstraints:constraints];
        
        [existingConstraints addObjectsFromArray:constraints];
        objc_setAssociatedObject(self, lx_ConstraintsKeyPointer, existingConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        [self lx_makeConstraints:constraints];
    }
}

- (void)lx_removeAllConstraints {
    NSArray *constraints = objc_getAssociatedObject(self, lx_ConstraintsKeyPointer);
    if (constraints) {
        [NSLayoutConstraint deactivateConstraints:constraints];
        objc_setAssociatedObject(self, lx_ConstraintsKeyPointer, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)lx_remakeConstraints:(NSArray<NSLayoutConstraint *> *(^)(UIView *make))block {
    [self lx_removeAllConstraints];
    [self lx_makeConstraints:block];
}

@end
