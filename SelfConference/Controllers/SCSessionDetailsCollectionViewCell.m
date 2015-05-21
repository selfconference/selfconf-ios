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
#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "SCSessionFeedbackViewController.h"
#import "UIColor+SCColor.h"
#import "SCSharedStoryboardInstances.h"
#import "UIView+SCUtilities.h"

typedef NS_ENUM(NSInteger, SCSessionDetailsTableViewSection) {
    /** Holds the name of the session */
    SCSessionDetailsTableViewSectionName,
    
    /** Holds the details of the session */
    SCSessionDetailsTableViewSectionAbstract,
    
    /** Holds details about the speaker(s) */
    SCSessionDetailsTableViewSectionSpeakerDetails,
    
    // Always at the end, so we can accurately count the number of enum options
    SCSessionDetailsTableViewSectionCount
};

static CGFloat const kCellShouldCollapseAfterDragOffset = 75.0f;

@interface SCSessionDetailsCollectionViewCell () <UITableViewDataSource, UITableViewDelegate, SCSessionNameTableViewCellDelegate, SCSessionFeedbackViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitFeedbackButton;

@property (nonatomic) SCSessionFeedbackViewController *sessionFeedbackViewController;

/** Returns the last known width */
@property (nonatomic) CGFloat previousWidth;

@end

@implementation SCSessionDetailsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Dynamic row heights
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0f;
    
    CGFloat cornerRadius = 10.0f;
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = cornerRadius;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.cornerRadius = cornerRadius;
    self.tableView.layer.cornerRadius = cornerRadius;
    
    [self.submitFeedbackButton setTitleColor:[UIColor SC_orange]
                                    forState:UIControlStateNormal];
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
    
    [self showOrHideSubmitFeedbackButton];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SCSessionDetailsTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
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
            
            sessionNameTableViewCell.delegate = self;
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
                        
        case SCSessionDetailsTableViewSectionSpeakerDetails: {
            SCSessionSpeakerDetailsTableViewCell *sessionSpeakerDetailsTableViewCell =
            [tableView
             dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionSpeakerDetailsTableViewCell class])
             forIndexPath:indexPath];
            
            sessionSpeakerDetailsTableViewCell.session = self.session;
            
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
    [self.delegate sessionDetailsCollectionViewCellDidTapEmbeddedTableViewCell:self];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        UITableView *tableView = self.tableView;
        
        CGPoint tableViewContentOffset = tableView.contentOffset;
        
        UICollectionViewLayoutAttributes *attributes = [self.delegate collectionViewLayoutAttributesForSessionDetailsCollectionViewCell:self];
        CGRect originFrame = attributes.frame;

        CGFloat tableViewContentOffsetY = tableViewContentOffset.y;

        // User is pulling down from the very top of the table
        if (tableViewContentOffsetY < 0) {
            CGFloat newY = -tableViewContentOffsetY;
            
            // Move 'self' downwards based on the scroll position
            self.frame = CGRectOffset(originFrame, 0, newY);
            
            // If we pass a certain threshold, go ahead and request to be
            // collapsed (only when the user flicked the table)
            if (!tableView.dragging &&
                newY > kCellShouldCollapseAfterDragOffset) {
                [self.delegate sessionDetailsCollectionViewCellDidTapEmbeddedTableViewCell:self];
            }
        }
        else {
            self.frame = originFrame;
        }
    }
}

#pragma mark - SCSessionNameTableViewCellDelegate

- (void)sessionNameTableViewCellDidUpdateFavorite:(SCSessionNameTableViewCell *)cell {
    [self.delegate sessionDetailsCollectionViewCellDidUpdateFavorite:self];
}

#pragma mark - UIButton actions

- (IBAction)didTapSubmitFeedbackButton:(id)sender {
    [self
     SC_flipWithOptions:UIViewAnimationOptionTransitionFlipFromLeft
     halfwayBlock:^(BOOL finished) {
         self.sessionFeedbackViewController =
         [[SCSharedStoryboardInstances sharedMainStoryboardInstance]
          instantiateViewControllerWithIdentifier:NSStringFromClass([SCSessionFeedbackViewController class])];
         
         self.sessionFeedbackViewController.delegate = self;
         self.sessionFeedbackViewController.session = self.session;
         
         [self.contentView SC_addAndFullyConstrainSubview:self.sessionFeedbackViewController.view];
     }
     completionBlock:NULL];
}

#pragma mark - SCSessionFeedbackViewControllerDelegate

- (void)sessionFeedbackViewControllerDidTapDismissButton:(SCSessionFeedbackViewController *)sessionFeedbackViewController {
    [self closeSessionFeedbackViewController];
}

- (void)sessionFeedbackViewControllerDidSuccessfullySubmitSessionFeedback:(SCSessionFeedbackViewController *)sessionFeedbackViewController {
    [self showOrHideSubmitFeedbackButton];
    [self closeSessionFeedbackViewController];
}

#pragma mark - Other

/** 
 Flips 'self' back around and removes '_sessionFeedbackViewController.view' 
 from view and nils out '_sessionFeedbackViewController', that way, we always 
 start with a fresh set of elements on the feedback screen.
 */
- (void)closeSessionFeedbackViewController {
    [self
     SC_flipWithOptions:UIViewAnimationOptionTransitionFlipFromRight
     halfwayBlock:^(BOOL finished) {
         [self.sessionFeedbackViewController.view removeFromSuperview];
         self.sessionFeedbackViewController = nil;
     }
     completionBlock:NULL];
}

/** 
 Shows or hides '_submitFeedbackButton' based on if session feedback has 
 already been collected or not. 
 */
- (void)showOrHideSubmitFeedbackButton {
    self.submitFeedbackButton.hidden = self.session.didSubmitFeedback;
}

@end
