//
//  PCHashtag.m
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCHashtag.h"

@implementation PCHashtag

@dynamic user;
@dynamic photo;
@dynamic hashTag;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"PCHashtag";
}


@end
