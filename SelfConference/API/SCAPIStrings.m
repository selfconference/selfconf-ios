//
//  SCAPIStrings.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCAPIStrings.h"

NSString * const kSCAPIServiceBaseUrlString = @"http://selfconf-dev.herokuapp.com/api";

const struct SCAPIRelativeUrlStrings SCAPIRelativeUrlStrings = {
    .events = @"events",
    .venues = @"venues",
    .sessions = @"sessions",
    .rooms = @"rooms",
    .speakers = @"speakers",
    .sponsors = @"sponsors",
    .sponsorLevels = @"sponsor_levels",
    .organizers = @"organizers",
    .feedbacks = @"feedbacks"
};

const struct SCAPIRequestKeys SCAPIRequestKeys = {
    .fromDate = @"from_date",
    .comments = @"comments",
    .vote = @"vote",
    .feedback = @"feedback"
};
