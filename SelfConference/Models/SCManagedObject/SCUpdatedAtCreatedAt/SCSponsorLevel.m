//
//  SponsorLevel.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSponsorLevel.h"
#import "SCSponsor.h"

@implementation SCSponsorLevel

@dynamic sponsorLevelID;
@dynamic name;
@dynamic photoUrlString;
@dynamic order;
@dynamic event;
@dynamic sponsors;

+ (NSArray *)sponsorLevelsWithSponsorsSortedByOrder:(NSArray *)sponsorLevels {
    NSArray *filteredSponsorLevels =
    [sponsorLevels filteredArrayUsingPredicate:[self predicateForSponsorsExist]];
    
    return
    [self objects:filteredSponsorLevels
    sortedByPropertyName:NSStringFromSelector(@selector(order))];
}

- (NSArray *)sponsorsSortedByName {
    return [SCSponsor sponsorsOrderedByName:self.sponsors.allObjects];
}

#pragma mark - Internal

/** 
 Returns an 'NSPredicate' instance that will return 'SCSponsorLevel' instances 
 that have at least 1 'sponsor'. 
 */
+ (NSPredicate *)predicateForSponsorsExist {
    return
    [NSPredicate predicateWithFormat:@"%K.@count >0",
     NSStringFromSelector(@selector(sponsors))];
}

@end
