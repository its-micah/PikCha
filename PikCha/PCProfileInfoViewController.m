//
//  PCProfileInfoViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCProfileInfoViewController.h"

@interface PCProfileInfoViewController ()

@end

@implementation PCProfileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
