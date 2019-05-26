//
//  SCCodeOfConductViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCCodeOfConductViewController.h"
#import "SelfConference-Swift.h"
@interface SCCodeOfConductViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SCCodeOfConductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor SC_offWhite];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Sometimes the text view isn't scrolled to the very top right away
    [self.textView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)didTapCloseBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
