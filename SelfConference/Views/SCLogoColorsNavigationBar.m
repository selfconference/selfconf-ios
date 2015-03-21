//
//  SCLogoColorsNavigationBar.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCLogoColorsNavigationBar.h"
#import "SCLogoColorsLineView.h"

@interface SCLogoColorsNavigationBar ()

/** A view that will serve as a bottom border that contains all of the logo colors. */
@property (nonatomic) SCLogoColorsLineView *logoColorsLineView;

@end

@implementation SCLogoColorsNavigationBar

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
    // Get rid of the default shadow bottom border
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
    
    // Add our custom bottom border
    [self addSubview:self.logoColorsLineView];
    
    [self setupConstraints];
}

/** Sets up the constraints for all subviews */
- (void)setupConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_logoColorsLineView);
    
    NSArray *visualFormats = @[@"V:[_logoColorsLineView(1)]|",
                               @"H:|[_logoColorsLineView]|"];
    
    for (NSString *visualFormat in visualFormats) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:visualFormat
                              options:0
                              metrics:nil
                              views:views]];
    }
}

#pragma mark - Lazy loading

- (SCLogoColorsLineView *)logoColorsLineView {
    if (!_logoColorsLineView) {
        _logoColorsLineView = [SCLogoColorsLineView new];
        _logoColorsLineView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _logoColorsLineView;
}

@end
