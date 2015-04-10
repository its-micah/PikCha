//
//  PCLikesViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCLikesViewController.h"
#import "PCLike.h"
#import <Parse/Parse.h>

@interface PCLikesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *likesTableView;
@property NSMutableArray *likesArray;
@property UIRefreshControl *refreshControl;

@end

@implementation PCLikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *navigationImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 19)];
    navigationImage.image = [UIImage imageNamed:@"headerImage"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 19)];
    [titleImageView addSubview:navigationImage];
    self.navigationItem.titleView = titleImageView;
    navigationImage.contentMode = UIViewContentModeScaleAspectFit;


    self.likesTableView.delegate = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.331 green:0.884 blue:1.000 alpha:1.000];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(loadLikes) forControlEvents:UIControlEventValueChanged];
    [self.likesTableView addSubview:self.refreshControl];
    self.likesTableView.alwaysBounceVertical = YES;

    [self loadLikes];
}

- (void)loadLikes {
    PFUser *currentUser = [PFUser currentUser];
    self.likesArray = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"PCLike"];
    [query whereKey:@"photoUser" equalTo:(PFUser *)currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PCLike *like in objects) {
            [self.likesArray addObject:like];
        }
        NSLog(@"Likes count: %li", objects.count);
        [self.likesTableView reloadData];
        if (self.refreshControl) {
            [self.refreshControl endRefreshing];
        }
    }];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    PCLike *pcLike = self.likesArray[indexPath.row];

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *likeTime = [dateFormatter stringFromDate:pcLike.createdAt];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ liked this at %@", pcLike.user.username, likeTime];
    
    PFFile *imageFile = [pcLike.photo originalImage];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:imageData];
            [cell layoutSubviews];
        }
    }];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likesArray.count;
}



@end
