//
//  PCComment.m
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCComment.h"

@implementation PCComment

@dynamic photo;
@dynamic user;
@dynamic comment;

+ (void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return @"PCComment";
}



@end
