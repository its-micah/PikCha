//
//  HomeTabBarController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCTabBarController.h"
#import "PCLoginViewController.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import <Parse/Parse.h>

@interface PCTabBarController ()

@end

@implementation PCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor blueColor];

   [self confirmUserLoggedIn];
}

- (void)confirmUserLoggedIn {

    NSString *username = [SSKeychain passwordForService:@"PikChaUser" account:@"username"];
    NSString *password = [SSKeychain passwordForService:@"PikCha" account:username];

    // login user
    if (password == nil) {
        password = @"";
        username = @"";
    }

    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"%@", @"Did log in");
                                        } else {
                                            NSLog(@"%@", @"Failed log in");
                                            [self presentLoginScreen];
                                        }
                                    }];



}

- (void)presentLoginScreen {
    PCLoginViewController *target = [self.storyboard instantiateViewControllerWithIdentifier:@"PCLoginTableViewController"];
    [self presentViewController:target animated:YES completion:nil];
}





@end
