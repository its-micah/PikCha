//
//  PCFeedViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCFeedViewController.h"
#import "PCFeedCollectionViewCell.h"
#import "PCPhoto.h"
#import "PCUser.h"
#import "PCLike.h"

@interface PCFeedViewController ()

<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property NSMutableArray *feedArray;

@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;


@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedArray = [NSMutableArray new];
    self.feedCollectionView.delegate = self;

    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    //[query whereKey:@"username" equalTo:@"a"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PCPhoto *object in objects) {
                [self.feedArray addObject:object];
            }
            [self.feedCollectionView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated {
//    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
//    //[query whereKey:@"username" equalTo:@"a"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
//
//            [self.feedArray removeAllObjects];
//            // Do something with the found objects
//            for (PCPhoto *object in objects) {
//                [self.feedArray addObject:object];
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(self.feedCollectionView.frame.size.width, self.feedCollectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PCFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.userImageView.layer.cornerRadius = 15;

    PFFile *usersPhoto = [self.feedArray[indexPath.row] originalImage];
    [usersPhoto getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.cellImageView.image = [UIImage imageWithData:imageData];
            [cell layoutSubviews];
        }
    }];

    PCUser *user = (PCUser *)[PFUser currentUser];
    if (user) {
        PFFile *imageFile = user.profileImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                cell.userImageView.image = [UIImage imageWithData:imageData];
            }
        }];
    }

    cell.usernameLabel.text = [self.feedArray[indexPath.row] username];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PCLike *likeMe = [PCLike new];

    PFUser *currentUser = [PFUser currentUser];
    likeMe.user = (PCUser *)currentUser;
    PCPhoto *photo = self.feedArray[indexPath.row];
    likeMe.photo = photo;
    likeMe.photoUser = photo.user;

    [likeMe saveInBackground];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedArray.count;
}



@end
