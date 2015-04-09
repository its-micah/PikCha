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
@end

@implementation PCLikesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.likesTableView.delegate = self;

    self.likesArray = [NSMutableArray new];
    PFUser *currentUser = [PFUser currentUser];

    PFQuery *query = [PFQuery queryWithClassName:@"PCLike"];
    [query whereKey:@"photoUser" equalTo:(PFUser *)currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PCLike *like in objects) {
            [self.likesArray addObject:like];
            NSLog(@"%@", like.photo.comment);
        }
        [self.likesTableView reloadData];
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    //Fix this. Make it work.
    PCLike *pcLike = self.likesArray[indexPath.row];

    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    NSString *likeTime = [dateFormatter stringFromDate:pcLike.createdAt];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ liked this on %@", pcLike.user.username, likeTime];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.likesArray.count;
}



@end
