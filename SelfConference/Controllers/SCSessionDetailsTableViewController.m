//
//  SCSessionDetailsViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionDetailsTableViewController.h"
#import "SCSessionNameTableViewCell.h"
#import "SCSessionAbstractTableViewCell.h"
#import "SCSessionSpeakerHeaderTableViewCell.h"
#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "UIColor+SCColor.h"
#import <MTDates/NSDate+MTDates.h>
#import "SCSession.h"

typedef NS_ENUM(NSInteger, SCSessionDetailsTableViewSection) {
    /** Holds the name of the session */
    SCSessionDetailsTableViewSectionName,
    
    /** Holds the details of the session */
    SCSessionDetailsTableViewSectionAbstract,
    
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
    self.navigationItem.title = [session.slot
                                 mt_stringFromDateWithFormat:@"EEEE ha"
                                 localized:YES];
    
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
        numberOfRows = self.session.speakersOrderedByName.count;
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
            
        case SCSessionDetailsTableViewSectionAbstract: {
            SCSessionAbstractTableViewCell *sessionAbstractTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionAbstractTableViewCell class])
             forIndexPath:indexPath];
            
            sessionAbstractTableViewCell.session = self.session;

            cell = sessionAbstractTableViewCell;
        } break;
            
        case SCSessionDetailsTableViewSectionSpeakerLabel: {
            SCSessionSpeakerHeaderTableViewCell *sessionSpeakerHeaderTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionSpeakerHeaderTableViewCell class])
             forIndexPath:indexPath];
            
            [sessionSpeakerHeaderTableViewCell
             configureWithNumberOfSpeakers:self.session.speakersOrderedByName.count];
            
            cell = sessionSpeakerHeaderTableViewCell;
        } break;
            
        case SCSessionDetailsTableViewSectionSpeakerDetails: {
            SCSessionSpeakerDetailsTableViewCell *sessionSpeakerDetailsTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionSpeakerDetailsTableViewCell class])
             forIndexPath:indexPath];
            
            sessionSpeakerDetailsTableViewCell.speaker =
            self.session.speakersOrderedByName[indexPath.row];
            
            cell = sessionSpeakerDetailsTableViewCell;
        } break;
            
        default: {
            NSAssert(NO, @"Unhandled session details row: %zd", indexPath.row);
        }
    }
    
    return cell;
}

@end
