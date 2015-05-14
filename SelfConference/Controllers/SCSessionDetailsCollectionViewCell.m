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

static CGFloat const kCellShouldCollapseAfterDragOffset = 75.0f;

@interface SCSessionDetailsCollectionViewCell () <UITableViewDataSource, UITableViewDelegate>

/** Returns the last known width */
@property (nonatomic) CGFloat previousWidth;

@end

@implementation SCSessionDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Dynamic row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0f;
    
    // Don't show empty cells at the end of the table
    self.tableView.tableFooterView = [UIView new];
    
    CGFloat cornerRadius = 10.0f;
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = cornerRadius;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.cornerRadius = cornerRadius;
    self.tableView.layer.cornerRadius = cornerRadius;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.session = nil;
    self.backgroundColor = self.defaultBackgroundColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    CGFloat currentWidth = CGRectGetWidth(bounds);
    
    if (self.previousWidth != currentWidth) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:bounds].CGPath;
        self.previousWidth = currentWidth;
    }
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate sessionDetailsCollectionViewCellShouldCollapse:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableView = self.tableView;
        
        CGPoint tableViewContentOffset = tableView.contentOffset;
        
        UIColor *newContentViewBackgroundColor;
        
        UICollectionViewLayoutAttributes *attributes = [self.delegate collectionViewLayoutAttributesForSessionDetailsCollectionViewCell:self];
        CGRect originFrame = attributes.frame;

        CGFloat tableViewContentOffsetY = tableViewContentOffset.y;

        // User is pulling down from the very top of the table
        if (tableViewContentOffsetY < 0) {
            CGFloat newY = -tableViewContentOffsetY;
            
            // Move 'self' downwards based on the scroll position
            self.frame = CGRectOffset(originFrame, 0, newY);
            
            // Don't show a white area above the session color
            newContentViewBackgroundColor = self.session.color;
            
            // If we pass a certain threshold, go ahead and request to be
            // collapsed (only when the user flicked the table)
            if (!tableView.dragging &&
                newY > kCellShouldCollapseAfterDragOffset) {
                [self.delegate sessionDetailsCollectionViewCellShouldCollapse:self];
            }
        }
        else {
            // If the user pulls up from the bottom, make sure to show the
            // default background color
            newContentViewBackgroundColor = self.defaultBackgroundColor;
            
            self.frame = originFrame;
        }
        
        // Set the 'backgroundColor' on 'self' directly that way we don't lose
        // our top rounded corners.
        self.backgroundColor = newContentViewBackgroundColor;
    }
}

/** The default '_backgroundColor' */
- (UIColor *)defaultBackgroundColor {
    return [UIColor whiteColor];
}

@end
