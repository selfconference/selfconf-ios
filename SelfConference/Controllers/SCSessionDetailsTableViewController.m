//
//  SCSessionDetailsViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionDetailsTableViewController.h"
#import "SCSessionNameTableViewCell.h"
#import "SCSessionDetailsTableViewCell.h"
#import "SCSessionSpeakerHeaderTableViewCell.h"
#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "UIColor+SCColor.h"
#import <MTDates/NSDate+MTDates.h>

typedef NS_ENUM(NSInteger, SCSessionDetailsTableViewSection) {
    /** Holds the name of the session */
    SCSessionDetailsTableViewSectionName,
    
    /** Holds the details of the session */
    SCSessionDetailsTableViewSectionDetails,
    
    /** Acts like a header to introduce the speaker(s) */
    SCSessionDetailsTableViewSectionSpeakerLabel,
    
    /** Holds details about the speaker(s) */
    SCSessionDetailsTableViewSectionSpeakerDetails,
    
    // Always at the end, so we can accurately count the number of enum options
    SCSessionDetailsTableViewSectionCount
};

@implementation SCSessionDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    // Dynamic row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0f;
    
    // Don't show empty cells at the end of the table
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated {
    // TODO: determine this based on the session
    self.navigationController.navigationBar.barTintColor = [UIColor SC_orange];
}

- (void)setSession:(SCSession *)session {
    /* TODO: Set the navigationItem.title to a localized version of session's
             slot time.
     
     self.navigationItem.title = [session.scheduledAt
                                 mt_stringFromDateWithFormat:@"EEEE ha"
                                 localized:YES];
     */
    
    _session = session;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SCSessionDetailsTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    
    // A session __could__ have more than 1 speaker
    if (section == SCSessionDetailsTableViewSectionSpeakerDetails) {
        // TODO: set 'numberOfRows' to the number of speakers
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case SCSessionDetailsTableViewSectionName: {
            SCSessionNameTableViewCell *sessionNameTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionNameTableViewCell class])
             forIndexPath:indexPath];
            
            sessionNameTableViewCell.session = self.session;
            
            cell = sessionNameTableViewCell;
        } break;
            
        case SCSessionDetailsTableViewSectionDetails: {
            SCSessionDetailsTableViewCell *sessionDetailsTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionDetailsTableViewCell class])
             forIndexPath:indexPath];
            
            sessionDetailsTableViewCell.session = self.session;

            cell = sessionDetailsTableViewCell;
        } break;
            
        case SCSessionDetailsTableViewSectionSpeakerLabel: {
            SCSessionSpeakerHeaderTableViewCell *sessionSpeakerHeaderTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionSpeakerHeaderTableViewCell class])
             forIndexPath:indexPath];
            
            // TODO: Call
            // '[sessionSpeakerHeaderTableViewCell configureWithNumberOfSpeakers:#]'
            // with the number of speakers
            
            cell = sessionSpeakerHeaderTableViewCell;
        } break;
            
        case SCSessionDetailsTableViewSectionSpeakerDetails: {
            SCSessionSpeakerDetailsTableViewCell *sessionSpeakerDetailsTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionSpeakerDetailsTableViewCell class])
             forIndexPath:indexPath];
            
            // TODO: set 'sessionSpeakerDetailsTableViewCell.speaker'
            
            cell = sessionSpeakerDetailsTableViewCell;
        } break;
            
        default: {
            NSAssert(NO, @"Unhandled session details row: %zd", indexPath.row);
        }
    }
    
    return cell;
}

@end
