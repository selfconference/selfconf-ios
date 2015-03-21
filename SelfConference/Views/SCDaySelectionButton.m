//
//  SCDaySelectionButton.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCDaySelectionButton.h"
#import "UIColor+SCColor.h"

@interface SCDaySelectionButton ()

/** The bottom border that is colored when the button is selected */
@property (nonatomic) UIView *bottomBorderView;

@end

@implementation SCDaySelectionButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor SC_teal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self addSubview:self.bottomBorderView];
    [self setupConstraints];
    
    // Make sure our overridden setter gets called
    self.selected = self.selected;
}

/** Sets up the constraints for all subviews */
- (void)setupConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_bottomBorderView);
    
    NSArray *visualFormats = @[@"V:[_bottomBorderView(2)]|",
                               @"H:|[_bottomBorderView]|"];
    
    for (NSString *visualFormat in visualFormats) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:visualFormat
                              options:0
                              metrics:nil
                              views:views]];
    }
}

#pragma mark - Lazy loading

- (UIView *)bottomBorderView {
    if (!_bottomBorderView) {
        _bottomBorderView = [UIView new];
        _bottomBorderView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _bottomBorderView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.bottomBorderView.backgroundColor =
    selected ?
    [UIColor SC_orange] :
    [UIColor clearColor];
}

@end
