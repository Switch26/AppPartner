//
//  ChatData.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/19/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatData.h"
#import "PhotoThumbnailAvailability.h"

@implementation ChatData
- (void)loadWithDictionary:(NSDictionary *)dict
{
    self.user_id = [[dict objectForKey:@"user_id"] intValue];
    self.username = [dict objectForKey:@"username"];
    self.avatar_url = [dict objectForKey:@"avatar_url"];
    self.message = [dict objectForKey:@"message"];
    
    // Using Grad Central Dispatch to load images asyncronisly
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do stuff on SECONDARY QUEUE
        UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatar_url]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Get MAIN queue back
            //Post notification when finished downloading
            [[NSNotificationCenter defaultCenter] postNotificationName:PhotoThumbnailAvailabilityNotification
                                                                object:self];
            
            self.avatarImage = thumbnailImage;
        });
    });
    
}
@end
