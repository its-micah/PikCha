//
//  HomeTabBarController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCTabBarController.h"
#import "PCLoginViewController.h"
#import "PCProfileViewController.h"
#import "SSKeychain.h"
#import "SSKeychainQuery.h"
#import <Parse/Parse.h>

@interface PCTabBarController () <PCProfileLogoutDelegate>

@end

@implementation PCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    self.tabBar.tintColor = [UIColor blueColor];
    ((PCProfileViewController *)((UITabBarController *)self.viewControllers[4]).viewControllers.firstObject).delegate = self;
=======
    self.tabBar.tintColor = [UIColor colorWithWhite:0.834 alpha:1.000];

>>>>>>> 3d7afcf7e594c0413b7bcbd1195add333746d060

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

- (void)logout {
    [PFUser logOut];

    NSString *username = [SSKeychain passwordForService:@"PikChaUser" account:@"username"];
    //NSString *password = [SSKeychain passwordForService:@"PikCha" account:username];


    //[SSKeychain setPassword:self.user.username forService:@"PikChaUser" account:@"username"];
    [SSKeychain setPassword:@"" forService:@"PikCha" account:username];

    [self.tabBarController setSelectedIndex:0];
    PCLoginViewController *target = [self.storyboard instantiateViewControllerWithIdentifier:@"PCLoginTableViewController"];
    [self presentViewController:target animated:YES completion:nil];
    
}



@end
