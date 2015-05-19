//
//  SCSponsorCollectionViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 5/19/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSponsorCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SCSponsor.h"

@interface SCSponsorCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SCSponsorCollectionViewCell

- (void)setSponsor:(SCSponsor *)sponsor {
    [self.imageView setImageWithURL:[NSURL URLWithString:sponsor.photoUrlString]];
    
    _sponsor = sponsor;
}

@end
