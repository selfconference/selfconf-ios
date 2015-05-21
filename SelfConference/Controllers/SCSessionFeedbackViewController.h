//
//  SCSessionFeedbackViewController.h
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCSession;

@protocol SCSessionFeedbackViewControllerDelegate;

@interface SCSessionFeedbackViewController : UIViewController

@property (nonatomic) SCSession *session;

@property (nonatomic, weak) id<SCSessionFeedbackViewControllerDelegate> delegate;

@end

@protocol SCSessionFeedbackViewControllerDelegate <NSObject>

/** Called when the user just wants to close without submitting feedback. */
- (void)sessionFeedbackViewControllerDidTapDismissButton:(SCSessionFeedbackViewController *)sessionFeedbackViewController;

/** Called when session feedback has been submitted successfully. */
- (void)sessionFeedbackViewControllerDidSuccessfullySubmitSessionFeedback:(SCSessionFeedbackViewController *)sessionFeedbackViewController;

@end
