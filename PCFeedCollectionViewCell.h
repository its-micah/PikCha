//
//  PCFeedCollectionViewCell.h
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCFeedCollectionViewDelegate <NSObject>

- (void)showSegue:(NSInteger)cellNumber;

@end

@interface PCFeedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property NSInteger cellNumber;
@property (nonatomic, assign) id <PCFeedCollectionViewDelegate> delegate;

- (void) animateLike;


@end
