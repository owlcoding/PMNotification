//
//  PMNotification.h
//
//  Created by Pawel Maczewski on 15/05/2017.
//  Copyright © 2017 Pawel Maczewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMNotification;
@class PMNotificationWindow;

@protocol PMNotificationDelegate <NSObject>

@optional
- (void)notificationViewDidStartHiding:(PMNotification *)notification;

- (void)notificationViewDidCancelHiding:(PMNotification *)notification;

- (void)notificationViewDidFinishHiding:(PMNotification *)notification;

- (void)notificationViewDidStartAppearing:(PMNotification *)notification;

- (void)notificationViewDidFinishAppearing:(PMNotification *)notification;

- (void)notificationTimeoutDidFire:(PMNotification *)notification;

@end

@protocol PMNotificationStyleSource <NSObject>

@optional
- (UIColor *)backgroundColor;

- (CGFloat)backgroundAlpha;

- (CGFloat)maximumNotificationViewHeight;

- (UIColor *)shadowColor;

@end

@interface PMNotification : UIView

@property(nonatomic, weak) id <PMNotificationDelegate> notificationDelegate;

@property(nonatomic, weak) id <PMNotificationStyleSource> styleSource;

@property(nonatomic, strong) PMNotificationWindow *displayingWindow;

@property(nonatomic, assign) CGFloat maximumNotificationViewHeight;

- (instancetype)initWithStyleSource:(id <PMNotificationStyleSource>)styleSource view:(UIView *)view;

- (void)showAnimated:(BOOL)animated hideAfter:(NSTimeInterval)seconds;

- (void)dismissAnimated:(BOOL)animated;

@end
