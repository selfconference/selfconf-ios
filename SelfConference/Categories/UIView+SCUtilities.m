//
//  UIView+SCUtilities.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "UIView+SCUtilities.h"

@implementation UIView (SCUtilities)

- (void)SC_makeCircular {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0f;
    self.clipsToBounds = YES;
}

- (void)SC_addAndFullyConstrainSubview:(UIView *)view {
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    
    NSArray *visualFormats = @[@"V:|[view]|",
                               @"H:|[view]|"];
    
    for (NSString *visualFormat in visualFormats) {
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:visualFormat
                              options:0
                              metrics:nil
                              views:views]];
    }
}

- (void)SC_flipWithOptions:(UIViewAnimationOptions)options
              halfwayBlock:(UIViewAnimationCompletionBlock)halfwayBlock
           completionBlock:(UIViewAnimationCompletionBlock)completionBlock {
    // With help from: https://github.com/minhntran/MTCardLayout
    CGFloat degree =
    (options & UIViewAnimationOptionTransitionFlipFromRight) ?
    -M_PI_2 :
    M_PI_2;
    
    CGFloat partialDuration = 0.2f;
    CGFloat distanceZ = 2000.0f;
    CGFloat translationZ = CGRectGetWidth(self.frame) / 2.0f;
    CGFloat scaleXY = (distanceZ - translationZ) / distanceZ;
    
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    
    rotationAndPerspectiveTransform.m34 = 1.0f / -distanceZ;
    
    rotationAndPerspectiveTransform =
    CATransform3DTranslate(rotationAndPerspectiveTransform,
                           0,
                           0,
                           translationZ);
    
    rotationAndPerspectiveTransform =
    CATransform3DScale(rotationAndPerspectiveTransform,
                       scaleXY,
                       scaleXY,
                       1.0);
    
    self.layer.transform = rotationAndPerspectiveTransform;
    
    [UIView
     animateWithDuration:partialDuration
     animations:^{
         self.layer.transform =
         CATransform3DRotate(rotationAndPerspectiveTransform,
                             degree,
                             0.0f,
                             1.0f,
                             0.0f);
     }
     completion:^(BOOL finished){
         if (halfwayBlock) {
             halfwayBlock(finished);
         }
         
         self.layer.transform =
         CATransform3DRotate(rotationAndPerspectiveTransform,
                             -degree,
                             0.0f,
                             1.0f,
                             0.0f);
         
         [UIView
          animateWithDuration:partialDuration
          animations:^{
              self.layer.transform = rotationAndPerspectiveTransform;
          }
          completion:^(BOOL finished){
              self.layer.transform = CATransform3DIdentity;
              
              if (completionBlock) {
                  completionBlock(finished);
              }
          }];
     }];
}

@end
