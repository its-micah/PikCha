//
//  PCHashtag.h
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <Parse/Parse.h>
#import "PCUser.h"
#import "PCPhoto.h"

@interface PCHashtag : PFObject

@property PCUser *user;
@property PCPhoto *photo;

@end
