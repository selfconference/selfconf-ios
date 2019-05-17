//
//  SCSessionFeedbackViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionFeedbackViewController.h"
#import "UIColor+SCColor.h"
#import "SCSession.h"
#import "UIView+MBProgressHUD.h"
#import "UIAlertController+SCAlertController.h"
@import IHKeyboardAvoiding;

@interface SCSessionFeedbackViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *thumbsUpOrDownSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

/** The placeholder text for '_textView' */
@property (nonatomic) NSString *placeholderText;

@end

@implementation SCSessionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor SC_teal];
    
    self.textView.backgroundColor = [UIColor SC_darkTeal];
    self.textView.layer.cornerRadius = 4.0f;
    
    self.textView.text = self.placeholderText;
    
    // Disabled by default, until the user changes the text. We want some kind
    // of comment to go along with the vote.
    [self enableSubmitButton:NO];
    
    [KeyboardAvoiding setAvoidingView:self.textView];
}

- (NSString *)placeholderText {
    if (!_placeholderText) {
        _placeholderText = @"Add your comments here...";
    }
    
    return _placeholderText;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.isTextViewEmpty) {
        textView.text = @"";
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self enableSubmitButton:!self.isTextViewEmpty];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (self.isTextViewEmpty) {
        textView.text = self.placeholderText;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    BOOL shouldChange = YES;
    
    // Since the return key is set up as a DONE key, hide the keyboard when
    // tapping it
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        shouldChange = NO;
    }
    
    return shouldChange;
}

#pragma mark - UIButton actions

- (IBAction)didTapSubmitButton:(id)sender {
    [self.view SC_showProgressHUDWithTitle:@"Sending Feedback..."];
    
    [self.session
     submitFeedbackToTheAPIWithVote:self.currentVote
     comments:self.textView.text
     completionBlock:^(BOOL success, NSError *error) {
         [self.view SC_hideProgressHUD];
         
         if (!success) {
             UIAlertController *alertController =
             [UIAlertController SC_alertControllerForSessionFeedbackFailedToSendToAPI];
             
             [self presentViewController:alertController
                                animated:YES
                              completion:NULL];
         }
         else {
             [self.delegate
              sessionFeedbackViewControllerDidSuccessfullySubmitSessionFeedback:self];
         }
     }];
}

- (IBAction)didTapDismissButton:(id)sender {
    [self.delegate sessionFeedbackViewControllerDidTapDismissButton:self];
}

#pragma mark - Other

/** Returns the current vote, as determined by '_thumbsUpOrDownSegmentedControl' */
- (SCSessionVote)currentVote {
    SCSessionVote currentVote;
    
    NSInteger selectedSegmentIndex =
    self.thumbsUpOrDownSegmentedControl.selectedSegmentIndex;
    
    if (selectedSegmentIndex == 0) {
        currentVote = SCSessionVoteThumbsUp;
    }
    else if (selectedSegmentIndex == 1) {
        currentVote = SCSessionVoteThumbsDown;
    }
    else {
        NSAssert(NO, @"Unknown SCSessionVote for selectedSegmentIndex");
    }
    
    return currentVote;
}

/** Returns 'YES' if '_textView.text' is either empty or set as '_placeholderText' */
- (BOOL)isTextViewEmpty {
    NSString *text = self.textView.text;
    
    return
    text.length == 0 ||
    [text isEqualToString:self.placeholderText];
}

/** Enables/disables '_submitButton' and makes sure the state is obvious. */
- (void)enableSubmitButton:(BOOL)shouldEnable {
    self.submitButton.enabled = shouldEnable;
    self.submitButton.alpha = shouldEnable ? 1.0f : 0.4f;
}

@end
