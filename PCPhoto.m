//
//  PCPhoto.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCPhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation PCPhoto

@dynamic photoID;
@dynamic username;
@dynamic comment;
@dynamic date;
@dynamic photolocation;
@dynamic originalImage;
@dynamic thumbnailImage;
@dynamic likes;
@dynamic tags;
@dynamic user;



+(void)load {
    [self registerSubclass];
}


+(NSString *)parseClassName {
    return @"PCPhoto";
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {

    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
