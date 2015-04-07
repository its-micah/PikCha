//
//  PCUser.h
//  PikCha
//
//  Created by Mick Lerche on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <Parse/Parse.h>

@interface PCUser : PFUser <PFSubclassing>

@property NSString *fullName;
@property NSString *bio;
@property NSString *website;
@property PFFile *profileImage;
@property NSString *phoneNumber;
@property NSString *gender; 

//+ (NSString *)parseClassName;


@end
