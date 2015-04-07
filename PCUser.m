//
//  PCUser.m
//  PikCha
//
//  Created by Mick Lerche on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation PCUser

@dynamic bio;
@dynamic username; 
@dynamic profileImage;
@dynamic fullName;
@dynamic website; 

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PCUser";
}


@end
