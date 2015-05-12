//
//  NSAttributeDescription+SCCAttributeDescription.h
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSAttributeDescription (SCAttributeDescription)

/**
 Sets 'dateFormat' as the value for
 '_userInfo[kMagicalRecordImportCustomDateFormatKey]'
 */
- (void)SC_setDateFormat:(NSString *)dateFormat;

@end
