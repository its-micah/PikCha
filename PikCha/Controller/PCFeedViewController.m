//
//  PCFeedViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCFeedViewController.h"
#import "PCPhoto.h"

@interface PCFeedViewController ()
@property NSMutableArray *feedArray;

@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    PFQuery *query = [PFQuery queryWithClassName:@"PCPhoto"];
    [query whereKey:@"username" equalTo:@"a"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu photos.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PCPhoto *object in objects) {

            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

@end
