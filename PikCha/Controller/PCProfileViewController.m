//
//  PCProfileViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileViewController.h"
#import "PCUserProfileCollectionViewCell.h"
#import "PCPhoto.h"

@interface PCProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *profileCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *userPhotoArray;

@end

@implementation PCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPhotos];

    self.collectionView.delegate = self;
    self.userPhotoArray = [NSMutableArray new];

    self.profileImageView.layer.cornerRadius = 37.5;

    self.nameLabel.text = self.user.username;
    self.user = (PCUser *)[PFUser currentUser];

    PFFile *userImageFile = self.user.profileImage;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileImageView.image = [UIImage imageWithData:imageData];
        }
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    [self loadPhotos];
   }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PCUserProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    PFFile *userImage = [self.userPhotoArray[indexPath.row] originalImage];
    [userImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.cellImageView.image = [UIImage imageWithData:imageData];
            [cell layoutSubviews];
        }
    }];

    return cell;

}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    return CGSizeMake(120, 120);
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPhotoArray.count;
}

- (void)loadPhotos {
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query whereKey:@"username" equalTo:@"a"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PCPhoto *object in objects) {
                NSLog(@"%@", object.comment);
                [self.userPhotoArray addObject:object];
            }
            [self.collectionView reloadData];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (IBAction)onEditProfileTapped:(id)sender {



}




@end
