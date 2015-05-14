//
//  SCScheduleDetailsCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 5/13/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionDetailsCollectionViewCell.h"
#import "SCSession.h"
#import <MTDates/NSDate+MTDates.h>
#import "SCSessionNameTableViewCell.h"
#import "SCSessionAbstractTableViewCell.h"
#import "SCSessionSpeakerHeaderTableViewCell.h"
#import "SCSessionSpeakerDetailsTableViewCell.h"

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

static CGFloat const kCellShouldCollapseAfterDragOffset = 125.0f;

@interface SCSessionDetailsCollectionViewCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CGFloat shadowWidth;

@end

@implementation SCSessionDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Dynamic row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0f;
    
    // Don't show empty cells at the end of the table
    self.tableView.tableFooterView = [UIView new];
    
    self.layer.cornerRadius = 10.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.session = nil;
}

- (void)setSession:(SCSession *)session {
    _session = session;
    
    [self.tableView reloadData];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableView = self.tableView;
        
        CGFloat tableViewYPosition = tableView.contentOffset.y;
        
        UIColor *newContentViewBackgroundColor;
        
        // User is pulling down from the very top of the table
        if (tableViewYPosition < 0) {
            CGFloat offset = -tableViewYPosition;
            
            // Move 'self' downwards based on the scroll position
            CGRect frame = self.frame;
            frame.origin.y = offset;
            self.frame = frame;
            
            // Don't show a white area above the session color
            newContentViewBackgroundColor = self.session.color;
            
            // If we pass a certain threshold, go ahead and request to be
            // collapsed
            if (!tableView.dragging &&
                offset > kCellShouldCollapseAfterDragOffset) {
                [self.delegate sessionDetailsCollectionViewCellShouldCollapse:self];
            }
        }
        else {
            // If the user pulls up from the bottom, make sure to show the
            // default background color
            newContentViewBackgroundColor = [UIColor whiteColor];
        }
        
        self.contentView.backgroundColor = newContentViewBackgroundColor;
    }
}

@end
