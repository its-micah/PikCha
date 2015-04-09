//
//  PCLike.m
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCLike.h"

@implementation PCLike

@dynamic user;
@dynamic photoUser;
@dynamic photo;



+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"PCLike";
}

@end
