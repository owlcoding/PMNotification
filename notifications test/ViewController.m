//
//  ViewController.m
//  notifications test
//
//  Created by Pawel Maczewski on 12/05/2017.
//  Copyright © 2017 Pawel Maczewski. All rights reserved.
//

#import "ViewController.h"
#import "NotificationInsideView.h"
#import "PMNotification.h"
#import "NotificationStyleSource.h"

@interface ViewController () <PMNotificationDelegate>

@property(nonatomic, assign) NSUInteger notificationNumber;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = [NSString stringWithFormat:@"%lu", (unsigned long) self.navigationController.viewControllers.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)notificationTitle {
    return [NSString stringWithFormat:@"Example notification %d from VC %@", self.notificationNumber, self.title];
}

- (IBAction)notify:(id)sender {
    self.notificationNumber++;

    NotificationInsideView *view = [[NotificationInsideView alloc] initWithImageName:@"warn"
                                                                               title:self.notificationTitle
                                                                                text:@"Maecenas tempor, augue non lobortis ullamcorper, magna eros mollis massa, a volutpat urna lacus et ligula. Nam et est sit amet ante egestas suscipit. Maecenas consequat nibh in consequat elementum. Quisque a libero a nunc porttitor facilisis. Donec ut lacinia felis. Praesent finibus eros quis pretium consequat. Cras vehicula, lorem non pretium tempor, quam est dignissim sem, eu dapibus magna urna quis dolor."];

    PMNotification *notification = [[PMNotification alloc] initWithStyleSource:[NotificationStyleSource new]
                                                                          view:view];
    view.owningNotification = notification;
    notification.notificationDelegate = self;

    [notification showAnimated:YES hideAfter:0];
}

- (IBAction)notifySmall:(id)sender {
    self.notificationNumber++;

    NotificationInsideView *view = [[NotificationInsideView alloc] initWithImageName:@"warn"
                                                                               title:
                                                                                       [NSString stringWithFormat:@"Small %@",
                                                                                                                  self.notificationTitle]
                                                                                text:@"Maecenas tempor, augue non lobortis ullamcorper, magna eros mollis massa, a volutpat urna lacus et ligula. Nam et est sit amet ante egestas suscipit. Maecenas consequat nibh in consequat elementum. Quisque a libero a nunc porttitor facilisis. Donec ut lacinia felis. Praesent finibus eros quis pretium consequat. Cras vehicula, lorem non pretium tempor, quam est dignissim sem, eu dapibus magna urna quis dolor."];

    PMNotification *notification = [[PMNotification alloc] initWithStyleSource:[NotificationStyleSource new]
                                                                          view:view];
    view.owningNotification = notification;
    notification.maximumNotificationViewHeight = 120;
    notification.notificationDelegate = self;

    [notification showAnimated:YES hideAfter:0];
}

@end
