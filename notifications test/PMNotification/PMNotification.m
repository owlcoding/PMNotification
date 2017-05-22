//
//  PMNotification.m
//
//  Created by Pawel Maczewski on 15/05/2017.
//  Copyright © 2017 Pawel Maczewski. All rights reserved.
//

#import "PMNotification.h"
#import "PMNotificationWindow.h"
#import <Masonry/Masonry.h>

@interface PMNotification ()

@property(strong, nonatomic) UIView *bgView;
@property(strong, nonatomic) UIView *view;

@property(nonatomic, strong) NSTimer *hideTimer;

@property(nonatomic, assign) BOOL isShown;
@property(nonatomic, assign) CGFloat panStartY;
@property(nonatomic, strong) MASConstraint *topConstraint;

@end

@implementation PMNotification

- (UIColor *)darkerColor:(UIColor *)baseColor {
    CGFloat h, s, b, a;
    if ([baseColor getHue:&h saturation:&s brightness:&b alpha:&a]) {
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.25f
                               alpha:a];
    }

    return nil;
}

- (void)setupShadow {
    UIColor *shadowColor = [self darkerColor:self.backgroundColor];
    if ([self.styleSource respondsToSelector:@selector(shadowColor)]) {
        shadowColor = self.styleSource.shadowColor;
    }

    self.bgView.layer.shadowColor = shadowColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(1, 2);
    self.bgView.layer.shadowRadius = 2;
    self.bgView.layer.shadowOpacity = 0.2;
    self.layer.masksToBounds = NO;
}

- (instancetype)initWithStyleSource:(id <PMNotificationStyleSource>)styleSource view:(UIView *)view {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _view = view;
        _styleSource = styleSource;

        CGFloat backgroundAlpha = 1.0f;
        if ([_styleSource respondsToSelector:@selector(backgroundAlpha)]) {
            backgroundAlpha = _styleSource.backgroundAlpha;
        }

        UIColor *backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:backgroundAlpha];
        if ([_styleSource respondsToSelector:@selector(backgroundColor)]) {
            backgroundColor = [_styleSource.backgroundColor colorWithAlphaComponent:backgroundAlpha];
        }

        self.backgroundColor = backgroundColor;

        if ([_styleSource respondsToSelector:@selector(maximumNotificationViewHeight)]) {
            self.maximumNotificationViewHeight = _styleSource.maximumNotificationViewHeight;
        } else {
            self.maximumNotificationViewHeight = 0;
        }

        _bgView = [UIView new];
        _bgView.backgroundColor = backgroundColor;
        [self addSubview:_bgView];
        [_bgView addSubview:view];

        self.isShown = NO;
        self.displayingWindow = nil;

        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(handlePan:)]];
        [self setupShadow];
        [self setNeedsUpdateConstraints];
    }

    return self;
}

- (void)updateConstraints {
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
        if (self.maximumNotificationViewHeight) {
            make.height.equalTo(@(self.maximumNotificationViewHeight));
        }
    }];

    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];

    if (self.displayingWindow) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.displayingWindow);
            if (self.isShown) {
                self.topConstraint = make.top.equalTo(self.displayingWindow);
            } else {
                make.bottom.equalTo(self.displayingWindow.mas_top).offset(-20);
            }
        }];
    }

    [super updateConstraints];
}

- (void)setVisibility:(BOOL)visibility withAnimationTime:(CGFloat)animationTime {

    __weak typeof(self) weakSelf = self;

    if (!self.superview) {
        if (!self.displayingWindow) {
            self.displayingWindow = [PMNotificationWindow newWindow];
        }

        [self.displayingWindow addSubview:self];
    }

    if (!visibility) {
        [self.hideTimer invalidate];
        self.hideTimer = nil;
    }

    [self.displayingWindow setStatusBarVisible:visibility animated:animationTime > 0];

    [self.superview layoutIfNeeded];
    self.isShown = visibility;
    [self setNeedsUpdateConstraints];

    CGFloat springDamping = visibility ? 0.8f : 1;

    [UIView animateWithDuration:animationTime
                          delay:0
         usingSpringWithDamping:springDamping
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         __strong typeof(self) strongSelf = weakSelf;
                         [strongSelf.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         __strong typeof(self) strongSelf = weakSelf;
                         if (visibility) {
                             if ([strongSelf.notificationDelegate respondsToSelector:@selector(notificationViewDidFinishAppearing:)]) {
                                 [strongSelf.notificationDelegate notificationViewDidFinishAppearing:strongSelf];
                             }
                         } else {
                             if ([strongSelf.notificationDelegate respondsToSelector:@selector(notificationViewDidFinishHiding:)]) {
                                 [strongSelf.notificationDelegate notificationViewDidFinishHiding:strongSelf];
                             }

                             [strongSelf removeFromSuperview];
                             strongSelf.displayingWindow = nil;
                         }
                     }];
}

- (void)showAnimated:(BOOL)animated {
    CGFloat time = animated ? 0.3f : 0;
    [self setVisibility:YES withAnimationTime:time];
}

- (void)showAnimated:(BOOL)animated hideAfter:(NSTimeInterval)seconds {
    if ([self.notificationDelegate respondsToSelector:@selector(notificationViewDidStartAppearing:)]) {
        [self.notificationDelegate notificationViewDidStartAppearing:self];
    }

    [self showAnimated:animated];
    if (seconds > 0) {
        self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                          target:self
                                                        selector:@selector(hideTimerFired)
                                                        userInfo:nil
                                                         repeats:NO];
    }
}

- (void)hideTimerFired {
    if ([self.notificationDelegate respondsToSelector:@selector(notificationTimeoutDidFire:)]) {
        [self.notificationDelegate notificationTimeoutDidFire:self];
    }

    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    CGFloat time = animated ? 0.3f : 0;
    [self setVisibility:NO withAnimationTime:time];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.panStartY = [panGestureRecognizer locationInView:self.superview].y;
            if ([self.notificationDelegate respondsToSelector:@selector(notificationViewDidStartHiding:)]) {
                [self.notificationDelegate notificationViewDidStartHiding:self];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat y = [panGestureRecognizer locationInView:self.superview].y;
            CGFloat diff = y - self.panStartY;
            if (diff <= 0) {
                [self.topConstraint setOffset:diff];
                [self.superview layoutIfNeeded];
            }

            break;
        }

        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            if ([panGestureRecognizer velocityInView:self.superview].y < -300) {
                [self dismissAnimated:YES];
            } else {
                CGFloat totalHeight = self.bounds.size.height;
                CGFloat y = [panGestureRecognizer locationInView:self.superview].y;
                CGFloat totalMovedUp = self.panStartY - y;
                if (totalMovedUp > totalHeight / 2) {
                    [self dismissAnimated:YES];
                } else {
                    if ([self.notificationDelegate respondsToSelector:@selector(notificationViewDidCancelHiding:)]) {
                        [self.notificationDelegate notificationViewDidCancelHiding:self];
                    }
                    [self showAnimated:YES];
                }
            }

            break;
        }
        case UIGestureRecognizerStatePossible:break;
    }
}

@end
