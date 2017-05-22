//
// Created by Pawel Maczewski on 15/05/2017.
// Copyright (c) 2017 Pawel Maczewski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMNotificationWindow : UIWindow

+ (instancetype)newWindow;

- (void)setStatusBarVisible:(BOOL)visible animated:(BOOL)animated;

@end