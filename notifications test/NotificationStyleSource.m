//
// Created by Pawel Maczewski on 16/05/2017.
// Copyright (c) 2017 Pawel Maczewski. All rights reserved.
//

#import "NotificationStyleSource.h"

@implementation NotificationStyleSource

- (UIColor *)backgroundColor {
    return [UIColor whiteColor];
}

- (CGFloat)backgroundAlpha {
    return 0.95;
}

- (CGFloat)maximumNotificationViewHeight {
    return 0;
}

- (UIColor *)shadowColor {
    return [UIColor blueColor];
}

@end