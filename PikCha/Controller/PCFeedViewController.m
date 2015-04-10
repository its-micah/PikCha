//
//  PCFeedViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCFeedViewController.h"
#import "PCFeedCollectionViewCell.h"
#import "PCProfileViewController.h"
#import "PCLoginViewController.h"
#import "PCCommentViewController.h"
#import "PCComment.h"
#import "PCPhoto.h"
#import "PCUser.h"
#import "PCLike.h"

@interface PCFeedViewController ()

<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
PCFeedCollectionViewDelegate
>

@property NSMutableArray *feedArray;
@property (weak, nonatomic) IBOutlet UICollectionView *feedCollectionView;
@property UIRefreshControl *refreshControl;
@property NSInteger cellNumber;

@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedArray = [NSMutableArray new];
    self.feedCollectionView.delegate = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.331 green:0.884 blue:1.000 alpha:1.000];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(loadPhotos) forControlEvents:UIControlEventValueChanged];
    [self.feedCollectionView addSubview:self.refreshControl];
    self.feedCollectionView.alwaysBounceVertical = YES;

    [self loadPhotos];

    UIImageView *navigationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 19)];
    navigationImage.image = [UIImage imageNamed:@"headerImage"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 19)];
    [titleImageView addSubview:navigationImage];
    self.navigationItem.titleView = titleImageView;
    navigationImage.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)viewDidAppear:(BOOL)animated {
    [self loadPhotos];
}

- (void)loadPhotos {
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
            // Do something with the found objects
            [self.feedArray removeAllObjects];
            for (PCPhoto *object in objects) {
                [self.feedArray addObject:object];
            }
            [self.feedCollectionView reloadData];
            if (self.refreshControl) {
                [self.refreshControl endRefreshing];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.feedCollectionView.frame.size.width, self.feedCollectionView.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PCFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    cell.userImageView.layer.cornerRadius = 15;
    cell.commentLabel.text = [self.feedArray[indexPath.row] comment];
    cell.delegate = self;
    cell.cellNumber = indexPath.row;

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    NSString *photoTime = [dateFormatter stringFromDate:[self.feedArray[indexPath.row] createdAt]];
    cell.timeStampLabel.text = photoTime;


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

    PFQuery *query = [PFQuery queryWithClassName:@"PCLike"];
    [query whereKey:@"photo" equalTo:(PCPhoto *)self.feedArray[indexPath.row]];
     [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSLog(@"Number of Likes: %i", number);
         cell.likesLabel.text = [NSString stringWithFormat:@"%i Likes", number];
        
    }];

    cell.usernameLabel.text = [self.feedArray[indexPath.row] username];
    return cell;
}

- (IBAction)onCommentButtonTapped:(UIButton *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Leave Comment" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        PFUser *currentUser = [PFUser currentUser];
        //photo(to be commented on) user(who is writing the comment) comment

        PCComment *comment = [PCComment new];
        comment.user = (PCUser *)currentUser;
        PCFeedCollectionViewCell *cell = (PCFeedCollectionViewCell *)button.superview;
        NSIndexPath *indexPath = [self.feedCollectionView indexPathForCell:cell];
        comment.photo = (PCPhoto *)self.feedArray[indexPath.row];
        comment.comment = ((UITextField *)alertController.textFields.firstObject).text;
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Adding a Comment");
            // refresh here
            [self.feedCollectionView reloadData];
        }];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PCFeedCollectionViewCell *cell = (PCFeedCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    PCPhoto *photo = self.feedArray[indexPath.row];
    PFUser *currentUser = [PFUser currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"PCLike"];
    [query whereKey:@"photo" equalTo:photo];
    [query whereKey:@"user" equalTo:(PFUser *)currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            PCLike *like = objects.firstObject;
            [like deleteInBackground];
            NSLog(@"Deleting a Like");

            // turn off like here
        } else {
            PCLike *likeMe = [PCLike new];
            likeMe.user = (PCUser *)currentUser;
            likeMe.photo = photo;
            likeMe.photoUser = photo.user;
            [likeMe saveInBackground];
            NSLog(@"Adding a Like");
            [cell animateLike];
            //turn on like here
        }
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.feedArray.count;
}


- (void)showSegue:(NSInteger)cellNumber{
        self.cellNumber = cellNumber;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)button {
    PCCommentViewController *vc = segue.destinationViewController;
    PCPhoto *photo = [PCPhoto new];
    photo = [self.feedArray objectAtIndex:self.cellNumber];
    vc.photo = photo;
}


//- (IBAction)onPicDoubleTapped:(UITapGestureRecognizer *)sender {
//    CGPoint point = [sender locationInView:self.feedCollectionView];
//    NSIndexPath *indexPath = [self.feedCollectionView indexPathForItemAtPoint:point];
//    PCLike *likeMe = [PCLike new];
//
//    PFUser *currentUser = [PFUser currentUser];
//    likeMe.user = (PCUser *)currentUser;
//    PCPhoto *photo = self.feedArray[indexPath.row];
//    likeMe.photo = photo;
//    likeMe.photoUser = photo.user;
//    NSLog(@"Hooray!! you liked me");
//
//    [likeMe saveInBackground];
//}



@end
