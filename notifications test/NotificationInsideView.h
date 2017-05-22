//
// Created by Pawel Maczewski on 16/05/2017.
// Copyright (c) 2017 Pawel Maczewski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMNotification;

@interface NotificationInsideView : UIView

- (instancetype)initWithImageName:(NSString *)imageNage title:(NSString *)title text:(NSString *)text;

@property(nonatomic, weak) PMNotification *owningNotification;

@end