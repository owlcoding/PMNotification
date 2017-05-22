//
// Created by Pawel Maczewski on 15/05/2017.
// Copyright (c) 2017 Pawel Maczewski. All rights reserved.
//

#import "PMNotificationWindow.h"
#import <Masonry/Masonry.h>

@interface PMNotificationWindow ()

@property(nonatomic, strong) UIView *statusBarCoverView;
@end

@implementation PMNotificationWindow

+ (instancetype)newWindow {
    PMNotificationWindow *window = [[PMNotificationWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    return window;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.hidden = NO;
        _statusBarCoverView = [UIView new];
        _statusBarCoverView.backgroundColor = [UIColor whiteColor];
        _statusBarCoverView.alpha = 0;
        [self addSubview:_statusBarCoverView];
        [_statusBarCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@([UIApplication sharedApplication].statusBarFrame.size.height));
        }];
    }

    return self;
}

- (void)setStatusBarVisible:(BOOL)visible animated:(BOOL)animated {
    __weak PMNotificationWindow *weakSelf = self;
    void(^visibilityBlock)() = ^{
        __strong PMNotificationWindow *strongSelf = weakSelf;
        strongSelf.statusBarCoverView.alpha = visible ? 1 : 0;
    };
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:visibilityBlock];
    } else {
        visibilityBlock();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestResult = [super hitTest:point withEvent:event];
    if ([hitTestResult isKindOfClass:[self class]]) {
        return nil;
    }

    return hitTestResult;
}

@end