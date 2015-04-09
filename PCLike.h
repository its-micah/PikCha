//
//  PCLike.h
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <Parse/Parse.h>
#import "PCPhoto.h"
#import "PCUser.h"

@interface PCLike : PFObject <PFSubclassing>

@property PCPhoto *photo;
@property PCUser *user;
@property PCUser *photoUser;

@end
