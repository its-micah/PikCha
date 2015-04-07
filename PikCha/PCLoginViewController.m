//
//  ViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCLoginViewController.h"
#import "PCUser.h"
#import "PCProfileInfoTableViewController.h"

@interface PCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property PCUser *user;
@property PCProfileInfoTableViewController *target;
@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onCreateAccountTapped:(id)sender {
    self.user = [PCUser new];
    self.user.username = self.usernameTextField.text;
    self.user.password = self.passwordTextField.text;

    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Yay!");
            [self performSegueWithIdentifier:@"ProfileInfoSegue" sender:nil];
//           self.target = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTableViewController"];
//            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:self.target];
//            navVC.title = @"Edit Your Profile!";
//            navVC.navigationItem.rightBarButtonItem = UIBarButtonItemStylePlain;
//            [self presentViewController:self.target animated:YES completion:nil];

            
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ProfileInfoSegue"]) {
        UINavigationController *navVC = segue.destinationViewController;
        PCProfileInfoTableViewController *profileVC = navVC.viewControllers.firstObject;
        profileVC.user = self.user;
    }
}

@end
