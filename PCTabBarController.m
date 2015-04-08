//
//  HomeTabBarController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCTabBarController.h"
#import <Parse/Parse.h>

@interface PCTabBarController ()

@end

@implementation PCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor blueColor];

    [PFUser logInWithUsernameInBackground:@"a" password:@"a"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            //self.user = user;
                                            NSLog(@"%@", @"Did log in");
                                        } else {
                                            NSLog(@"%@", @"Failed log in");
                                        }
                                    }];

}




@end
