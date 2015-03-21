//
//  SCLogoColorsLineView.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCLogoColorsLineView.h"
#import "UIColor+SCColor.h"

@interface SCLogoColorsLineView ()

@property (nonatomic) UIView *firstColorView;
@property (nonatomic) UIView *secondColorView;
@property (nonatomic) UIView *thirdColorView;
@property (nonatomic) UIView *fourthColorView;
@property (nonatomic) UIView *fifthColorView;

@end

@implementation SCLogoColorsLineView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    for (UIView *subview in @[self.firstColorView,
                              self.secondColorView,
                              self.thirdColorView,
                              self.fourthColorView,
                              self.fifthColorView]) {
        [self addSubview:subview];
    }
    
    [self setupConstraints];
}

/** Sets up the constraints for all subviews */
- (void)setupConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_firstColorView,
                                                         _secondColorView,
                                                         _thirdColorView,
                                                         _fourthColorView,
                                                         _fifthColorView);
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[_firstColorView]|"
                          options:0
                          metrics:nil
                          views:views]];
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[_firstColorView][_secondColorView(_firstColorView)][_thirdColorView(_firstColorView)][_fourthColorView(_firstColorView)][_fifthColorView(_firstColorView)]|"
                          options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                          metrics:nil
                          views:views]];
}

#pragma mark - Lazy loading

- (UIView *)firstColorView {
    if (!_firstColorView) {
        _firstColorView = [UIView new];
        _firstColorView.translatesAutoresizingMaskIntoConstraints = NO;
        _firstColorView.backgroundColor = [UIColor SC_purple];
    }
    
    return _firstColorView;
}

- (UIView *)secondColorView {
    if (!_secondColorView) {
        _secondColorView = [UIView new];
        _secondColorView.translatesAutoresizingMaskIntoConstraints = NO;
        _secondColorView.backgroundColor = [UIColor SC_red];
    }
    
    return _secondColorView;
}

- (UIView *)thirdColorView {
    if (!_thirdColorView) {
        _thirdColorView = [UIView new];
        _thirdColorView.translatesAutoresizingMaskIntoConstraints = NO;
        _thirdColorView.backgroundColor = [UIColor SC_orange];
    }
    
    return _thirdColorView;
}

- (UIView *)fourthColorView {
    if (!_fourthColorView) {
        _fourthColorView = [UIView new];
        _fourthColorView.translatesAutoresizingMaskIntoConstraints = NO;
        _fourthColorView.backgroundColor = [UIColor SC_yellow];
    }
    
    return _fourthColorView;
}

- (UIView *)fifthColorView {
    if (!_fifthColorView) {
        _fifthColorView = [UIView new];
        _fifthColorView.translatesAutoresizingMaskIntoConstraints = NO;
        _fifthColorView.backgroundColor = [UIColor SC_teal];
    }
    
    return _fifthColorView;
}

@end
