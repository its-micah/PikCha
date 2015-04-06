//
//  ViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCLoginViewController.h"

@interface PCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onCreateAccountTapped:(id)sender {
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameTextField.text;
    newUser.password = self.passwordTextField.text;

    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Yay!");
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WOAH NOW" message:@"You don't have an account" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];

    [self resignFirstResponder];

}

- (IBAction)onLoginTapped:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //go to user feed
            NSLog(@"HI %@", user.username);
        } else {
            //login failed.
            NSLog(@"%@", error);
        }
    }];
}

@end
