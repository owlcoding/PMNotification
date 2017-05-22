//
// Created by Pawel Maczewski on 16/05/2017.
// Copyright (c) 2017 Pawel Maczewski. All rights reserved.
//

#import "NotificationInsideView.h"
#import "PMNotification.h"
#import <Masonry/Masonry.h>

@interface NotificationInsideView ()

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIImageView *iconView;

@property(nonatomic, strong) UIButton *button1;

@end

@implementation NotificationInsideView

- (instancetype)initWithImageName:(NSString *)imageNage title:(NSString *)title text:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNage]];
        [_iconView setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
        [_iconView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                   forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:_iconView];

        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [_closeButton addTarget:self
                         action:@selector(closeTap:)
               forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setContentHuggingPriority:UILayoutPriorityRequired
                                        forAxis:UILayoutConstraintAxisHorizontal];
        [_closeButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                      forAxis:UILayoutConstraintAxisHorizontal];

        _titleLabel = [self makeTitleLabel];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];

        _textLabel = [self makeTextLabel];
        [_textLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                    forAxis:UILayoutConstraintAxisVertical];
        _textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
        _textLabel.text = text;

        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitle:@"Button 1" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_button1 setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.2] ];
        _button1.layer.borderWidth = 0.5;
        _button1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_button1];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (UILabel *)makeTitleLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.7;
    label.textColor = [UIColor darkTextColor];
    return label;
}

- (UILabel *)makeTextLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:@"AvenirNext-Medium" size:11];
    label.textAlignment = NSTextAlignmentJustified;
    label.textColor = [UIColor darkTextColor];
    return label;
}

- (void)updateConstraints {
    [_iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(8);
    }];

    [_closeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(8);
        make.centerY.equalTo(_iconView);
        make.right.equalTo(_closeButton.mas_left).offset(-8);
    }];

    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(_titleLabel);
    }];

    [_button1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textLabel.mas_bottom).offset(8);
        make.left.equalTo(_textLabel);
        make.width.equalTo(@(100));
        make.bottom.equalTo(self).offset(-8);
    }];

    [super updateConstraints];
}

- (void)closeTap:(id)sender {
    [self.owningNotification dismissAnimated:YES];
}

@end