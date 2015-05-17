//
//  SCViewWithCommonCoderAndFrameInitializer.h
//  SelfConference
//
//  Created by Jeff Burt on 5/17/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLabelWithCommonCoderAndFrameInitializer : UILabel

/** 
 A common initializer that is called when 'self' is created in code or in 
 Interface Builder. 
 */
- (void)commonCoderAndFrameInitializer;

@end
