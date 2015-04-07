//
//  PCProfileInfoTableViewController.m
//  PikCha
//
//  Created by Cameron Flowers on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileInfoTableViewController.h"
#import "PCProfileViewController.h"
#import <Parse/Parse.h>
#import "PCUser.h"

@interface PCProfileInfoTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *profileNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *websiteTextField;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@end

@implementation PCProfileInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.userNameLabel.text = self.user.username; 

}


- (IBAction)onDoneButtonTapped:(id)sender {
    self.user.fullName = self.profileNameTextField.text;
    self.user.website = self.websiteTextField.text;
    NSLog(@"%@", self.user.website);
    self.user.bio = self.bioTextView.text;
    self.user.email = self.emailTextField.text;
    self.user.phoneNumber = self.phoneTextField.text;
    self.user.gender = self.genderTextField.text;


    NSData *imageData = UIImagePNGRepresentation(self.profilePictureImageView.image);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [imageFile saveInBackground];
    self.user.profileImage = imageFile;


    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Hooray! We're Saved");
            //THIS IS WHERE WE GOTTA PUSH // 
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"%@", error);
        }
    }];
}


- (IBAction)onAddImageButtonTapped:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.profilePictureImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowProfileSegue"]) {
        UITabBarController *tabVC = segue.destinationViewController;
        PCProfileViewController *profileVC = [tabVC.viewControllers objectAtIndex:3];
        profileVC.user = self.user;

    }
}

@end
