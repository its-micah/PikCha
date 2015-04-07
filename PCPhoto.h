//
//  PCPhoto.h
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <Parse/Parse.h>

@interface PCPhoto : PFObject <PFSubclassing>

+(NSString *)parseClassName;

@property NSString *photoID;
@property NSString *username;
@property NSString *comment;
@property NSDate *date;
@property PFGeoPoint *photolocation;
@property PFFile *originalImage;
@property PFFile *thumbnailImage;
@property NSSet *tags;
@property int likes;



@end
