//
//  PCProfileViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileViewController.h"

@interface PCProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *profileCollectionView;

@end

@implementation PCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameLabel.text = self.user.username;

    PFFile *userImageFile = self.user.profileImage;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:imageData];
        }
    }];

}

- (IBAction)onEditProfileTapped:(id)sender {



}




@end
