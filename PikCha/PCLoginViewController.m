//
//  ViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCLoginViewController.h"

@interface PCLoginViewController ()

@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onCreateAccountTapped:(id)sender {
    PFUser *newUser = [PFUser user];
    newUser.username = self.username;
    newUser.password = self.password;

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Yay!");
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WOAH NOW" message:@"You don't have an account" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];

}

- (IBAction)onLoginTapped:(id)sender {

    
}

@end
