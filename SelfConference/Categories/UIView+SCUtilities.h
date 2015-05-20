//
//  UIView+SCUtilities.h
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIViewAnimationCompletionBlock)(BOOL finished);

@interface UIView (SCUtilities)

/** Rounds the view based on its width */
- (void)SC_makeCircular;

/** Adds 'view' as a subview and fully constrains it to 'self' */
- (void)SC_addAndFullyConstrainSubview:(UIView *)view;

/** 
 Flips 'self' with the given options. Can pass 
 'UIViewAnimationOptionTransitionFlipFromLeft' or 
 'UIViewAnimationOptionTransitionFlipFromRight' for the best effect. 
 */
- (void)SC_flipWithOptions:(UIViewAnimationOptions)options
              halfwayBlock:(UIViewAnimationCompletionBlock)halfwayBlock
           completionBlock:(UIViewAnimationCompletionBlock)completionBlock;

@end
