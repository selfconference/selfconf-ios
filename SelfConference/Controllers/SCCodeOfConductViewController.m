//
//  SCCodeOfConductViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 5/20/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCCodeOfConductViewController.h"
#import "UIColor+SCColor.h"

@implementation SCCodeOfConductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor SC_offWhite];
}

- (IBAction)didTapCloseBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
