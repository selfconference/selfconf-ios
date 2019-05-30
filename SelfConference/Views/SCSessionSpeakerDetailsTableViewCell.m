//
//  SCSessionSpeakerDetailsTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionSpeakerDetailsTableViewCell.h"
#import "SCSpeaker.h"
#import "SelfConference-Swift.h"
#import "UIView+SCUtilities.h"
#import "SCSession.h"
#import "SCSpeakerCollectionViewCell.h"

@interface SCSessionSpeakerDetailsTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *biographyLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SCSessionSpeakerDetailsTableViewCell

- (void)setSession:(SCSession *)session {
    if (session.speakers.count > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"About %@",
                               session.joinedSpeakerNamesOrderedByName];
    }
    else {
        self.nameLabel.text = nil;
    }
    
    SCSpeaker *oneSpeaker = session.speakers.anyObject;
    self.biographyLabel.text = oneSpeaker.biography;
    
    [self.collectionView reloadData];
    
    _session = session;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.session.speakersOrderedByName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSpeakerCollectionViewCell *cell =
    (SCSpeakerCollectionViewCell *)[collectionView
                                    dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SCSpeakerCollectionViewCell class])
                                    forIndexPath:indexPath];
    
    cell.speaker = self.session.speakersOrderedByName[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SCSpeakerCollectionViewCell *cell =
    (SCSpeakerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    // Since we cannot present view controllers (aka an alert), we need to
    // notify a view controller to do this for us.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kSCSpeakerOpenTwitterProfileForSpeakerNotificationName
     object:cell.speaker];
}

@end
