//
//  SCDayScheduleTableViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCScheduleTableViewController.h"
#import "SCSessionTableViewCell.h"
#import "SCSessionsInADayHeaderTableViewCell.h"
#import "SCSessionDetailsTableViewController.h"

/** The Storyboard segue that fires when selecting an 'SCSessionTableViewCell' */
static NSString * const kSCSessionTableViewCellShowSessionDetailsSegue =
@"SCSessionTableViewCellShowSessionDetailsSegue";

@interface SCScheduleTableViewController () <UISplitViewControllerDelegate>

/** An array of 'SCSession' instances */
@property (nonatomic) NSArray *sessions;

@end

@implementation SCScheduleTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitViewController.delegate = self;
    
    // Dynamic row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    self.tableView.estimatedRowHeight = 150.0f;
    self.tableView.estimatedSectionHeaderHeight = 50.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sessions.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.sessions[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCSessionTableViewCell *cell =
    [tableView
     dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionTableViewCell class])
     forIndexPath:indexPath];
    
    cell.session = self.sessions[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    SCSession *firstSessionInSection = [self.sessions[section] firstObject];
    
    SCSessionsInADayHeaderTableViewCell *sessionsInADayHeaderTableViewCell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionsInADayHeaderTableViewCell class])];
    
    // TODO: call
    // '[sessionsInADayHeaderTableViewCell configureWithDate:date]' with the
    // session slot time.
    
    return sessionsInADayHeaderTableViewCell.contentView;
}

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    __block BOOL shouldCollapse = NO;
    
    // When the user first opens the app, make sure to show the table view
    // controller and not the session details
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shouldCollapse = YES;
    });
    
    return shouldCollapse;
}

#pragma mark - Other

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSCSessionTableViewCellShowSessionDetailsSegue]) {
        SCSessionTableViewCell *sessionTableViewCell = (SCSessionTableViewCell *)sender;
        
        SCSessionDetailsTableViewController *sessionDetailsTableViewController =
        (SCSessionDetailsTableViewController *)[segue.destinationViewController viewControllers].firstObject;
        
        sessionDetailsTableViewController.session = sessionTableViewCell.session;
    }
}

@end
