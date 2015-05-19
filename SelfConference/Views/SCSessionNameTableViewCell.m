//
//  SCSessionNameTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionNameTableViewCell.h"
#import "SCSession.h"
#import <MTDates/NSDate+MTDates.h>
#import "SCRoom.h"
#import "SCSpeaker.h"
#import <MagicalRecord/MagicalRecord+Actions.h>
#import <MagicalRecord/NSManagedObject+MagicalRecord.h>

@interface SCSessionNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotAndRoomLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation SCSessionNameTableViewCell

#pragma mark - Overrides

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = [NSString stringWithFormat:@"%@: %@",
                           session.joinedSpeakerNamesOrderedByName,
                           session.name];
    
    self.slotAndRoomLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                  [session.slot
                                   mt_stringFromDateWithFormat:@"EEEE ha"
                                   localized:YES],
                                  session.room.name];
    
    [self setFavoriteButtonImageForIsFavorite:session.isFavorite];
    
    _session = session;
}

#pragma mark - UIButton actions

- (IBAction)didTapFavoriteButton:(UIButton *)button {
    // Toggle the setting
    BOOL newIsFavoriteValue = !self.session.isFavorite;
    
    // This save is super fast, so we don't really need to worry about making
    // the UI feel snappy by updating it before the save.
    [MagicalRecord
     saveWithBlock:^(NSManagedObjectContext *localContext) {
         SCSession *localSession = [self.session MR_inContext:localContext];
         localSession.isFavorite = newIsFavoriteValue;
     }
     completion:^(BOOL contextDidSave, NSError *error) {
         if (contextDidSave) {
             [self.session refreshOnDefaultContext];
             [self setFavoriteButtonImageForIsFavorite:newIsFavoriteValue];
             [self.delegate sessionNameTableViewCellDidUpdateFavorite:self];
         }
     }];
}

#pragma mark - Other

/** Sets the image on '_favoriteButton' based on '_session.isFavorite'. */
- (void)setFavoriteButtonImageForIsFavorite:(BOOL)isFavorite {
    UIImage *newFavoriteImage =
    isFavorite ?
    [UIImage imageNamed:@"tealFilledHeart"] :
    [UIImage imageNamed:@"tealUnfilledHeart"];
    
    [self.favoriteButton setImage:newFavoriteImage forState:UIControlStateNormal];
}

@end
