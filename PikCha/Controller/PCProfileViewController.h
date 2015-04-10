//
//  PCProfileViewController.h
//  PikCha
//
//  Created by Mick Lerche on 4/6/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUser.h"

@protocol PCProfileLogoutDelegate <NSObject>

- (void)logout;

@end


@interface PCProfileViewController : UIViewController

@property PCUser *user;

@property (nonatomic, assign) id <PCProfileLogoutDelegate> delegate;


@end
