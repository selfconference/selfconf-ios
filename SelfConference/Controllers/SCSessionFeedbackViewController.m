//
//  SCSessionFeedbackViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionFeedbackViewController.h"
#import "UIColor+SCColor.h"

@interface SCSessionFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *thumbsUpOrDownSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SCSessionFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor SC_teal];
    
    self.textView.backgroundColor = [UIColor SC_darkTeal];
    self.textView.layer.cornerRadius = 4.0f;
}

#pragma mark - UIButton actions

- (IBAction)didTapSubmitButton:(id)sender {
    // TODO: Submit feedback for the session
}

@end
