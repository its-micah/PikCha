//
//  PCProfileViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileViewController.h"
#import "PCUserProfileCollectionViewCell.h"
#import "PCCollectionReusableView.h"
#import "PCPhoto.h"

@interface PCProfileViewController ()

<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate
>


@property (weak, nonatomic) IBOutlet UICollectionView *profileCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *userPhotoArray;
@property PCCollectionReusableView *reusableView;

@end

@implementation PCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.delegate = self;
    //self.userPhotoArray = [NSMutableArray new];

    self.reusableView.profileImageView.layer.cornerRadius = 37.5;

//    self.user = (PCUser *)[PFUser currentUser];


    PFFile *userImageFile = self.user.profileImage;
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.reusableView.profileImageView.image = [UIImage imageWithData:imageData];
        }
    }];

}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadPhotos];
    [self loadInfo];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableView = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        PCCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        reusableView = headerView;
    }

    return reusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPhotoArray.count;
}

- (void)loadPhotos {
    self.userPhotoArray = [NSMutableArray new];
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

- (void)loadInfo {
    PCUser *user = [PCUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query whereKey:@"user" equalTo:user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSLog(@"Number of Pics: %i", number);
        self.reusableView.postsLabel.text = [NSString stringWithFormat:@"%i posts", number];
    }];
//    self.reusableView.infoLabel =
    self.reusableView.infoLabel.text = user.bio;
    self.reusableView.websiteLabel.text = user.website;
    self.reusableView.nameLabel.text = user.username;


}

- (IBAction)onEditProfileTapped:(id)sender {



}




@end
