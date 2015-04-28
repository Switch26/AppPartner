//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"
#import "PhotoThumbnailAvailability.h"

@interface ChatCell ()
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property int userID;
@end 

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    self.userImage.clipsToBounds = YES;
    
    
}


- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;
    self.userID = chatData.user_id;
    self.userImage.image = chatData.avatarImage;
    
    // listen to notification "PhotoThumbnailAvailabiliy to update the thumbnail when becomes available
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoThumbnailAvailabilityNotification
                                                      object:nil // Who can send it (nil = anyone)
                                                       queue:nil // nil = queue that I am on now
                                                  usingBlock:^(NSNotification *note) {
                                                      self.userImage.image = chatData.avatarImage;
                                                  }];
    
}
@end
