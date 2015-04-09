//
//  PCSearchViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCSearchViewController.h"
#import "PCPhoto.h"
#import "PCUser.h"

@interface PCSearchViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate >

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *searchResults;
@end

@implementation PCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.searchResults = [NSMutableArray new];

}

- (IBAction)onSelectSegmentedControl:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0: //show people
            self.searchBar.placeholder = @"Find Users";
            break;
        case 1: //show hashtags
            self.searchBar.placeholder = @"Find Hashtags";
            break;
        default:
            break;
    }

}

#pragma mark - Query

-(void)searchQuery:(NSString *)key{

    if (self.segmentedController.selectedSegmentIndex == 0) {
//Find People
        PFQuery *query = [PFQuery queryWithClassName:@"PCUser"];
        [query whereKey:@"username" equalTo:key];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %lu users.", (unsigned long)objects.count);
                // Do something with the found objects
                for (PCUser *object in objects) {
                    [self.searchResults addObject:object];
                }
                [self.searchTableView reloadData];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            [self.searchTableView reloadData];
        }];
    }

    else{
        //find hashtags
        [self.searchResults addObject:key];
    }


}
#pragma mark - Table View Functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    if(self.segmentedController.selectedSegmentIndex == 0){
    PCUser *user = self.searchResults[indexPath.row];
        cell.textLabel.text = user.username;
    }

    else{
        cell.textLabel.text = self.searchResults[indexPath.row];
        cell.detailTextLabel.text = @"We Looking For Those Hashtags Homie";
    }

    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self searchQuery:searchText];
}

@end
