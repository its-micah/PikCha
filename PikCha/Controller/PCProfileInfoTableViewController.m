//
//  PCProfileInfoTableViewController.m
//  PikCha
//
//  Created by Cameron Flowers on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileInfoTableViewController.h"
#import <Parse/Parse.h>
#import "PCUser.h"

@interface PCProfileInfoTableViewController ()
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


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
