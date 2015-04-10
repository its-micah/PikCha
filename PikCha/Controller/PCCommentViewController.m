//
//  PCCommentViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/10/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCCommentViewController.h"

@interface PCCommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *commentsArray;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@end

@implementation PCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.commentsArray = [NSMutableArray new];

    //PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"PCComment"];
    [query whereKey:@"photo" equalTo:self.photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            for (PCPhoto *photo in objects) {
                [self.commentsArray addObject:photo];
                [self.commentTableView reloadData];
            }
        } else {


        }
        
    }];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    cell.textLabel.text = ((PCComment *)self.commentsArray[indexPath.row]).user.username;
    cell.detailTextLabel.text = ((PCComment *)self.commentsArray[indexPath.row]).comment;

    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
