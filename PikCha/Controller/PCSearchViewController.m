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
#import "PCHashtag.h"

@interface PCSearchViewController ()
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate >

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *searchResults;
@end

@implementation PCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.searchResults = [NSMutableArray new];
    self.searchBar.placeholder = @"Find People";
    [self.segmentedController setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:                                                         [UIFont fontWithName:@"Avenir" size:13.0], NSFontAttributeName, nil] forState:UIControlStateNormal];


}

- (IBAction)onSelectSegmentedControl:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0: //show people
            self.searchBar.placeholder = @"Find People";
            break;
        case 1: //show hashtags
            self.searchBar.placeholder = @"Find HashTags";
            break;
        default:
            break;
    }

}

#pragma mark - Query

-(void)searchQuery:(NSString *)key{
    if ([key isEqualToString:@""]) { return; }
    if (self.segmentedController.selectedSegmentIndex == 0) {
//Find People
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKeyExists:@"fullName"];
        [query whereKey:@"fullName" matchesRegex:key modifiers:@"i"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                self.searchResults = [NSMutableArray new];
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
    } else {

        NSMutableSet *uniqueHashTags = [NSMutableSet new];

        PFQuery *query = [PFQuery queryWithClassName:@"PCHashtag"];
        [query whereKeyExists:@"hashTag"];
        [query whereKey:@"hashTag" matchesRegex:key modifiers:@"i"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count > 0) {
                for (PCHashtag *hashtag in objects) {
                    [uniqueHashTags addObject:hashtag.hashTag];
                    // this will be where you add photos to an array then reload
                    NSLog(@"%@", hashtag.hashTag);
                    NSLog(@"unique count %lu", uniqueHashTags.count);
                }
                NSLog(@"HashTags for hashtag search: %lu", (unsigned long)objects.count);
                self.searchResults = uniqueHashTags.allObjects;
                [self.searchTableView reloadData];
            } else {
                NSLog(@"No hash tags for this search");
            }
        }];
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
        cell.textLabel.text = user.fullName;
        cell.detailTextLabel.text = user.username;
    }

    else{
        cell.textLabel.text = [NSString stringWithFormat:@"#%@", self.searchResults[indexPath.row]];


        NSString *searchText = self.searchResults[indexPath.row];
        PFQuery *query = [PFQuery queryWithClassName:@"PCHashtag"];
        [query whereKey:@"hashTag" equalTo:searchText];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            // set the cell value here
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", number];
            NSLog(@"Count of HashTag (%@): %i", searchText, number);
        }];
    }

    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self searchQuery:searchText];
}

@end
