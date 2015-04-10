//
//  PCFeedCollectionViewCell.m
//  PikCha
//
//  Created by Micah Lanier on 4/8/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCFeedCollectionViewCell.h"

@implementation PCFeedCollectionViewCell


- (void) animateLike {
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.likeImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.likeImageView.alpha = 1.0;
    }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                             self.likeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                                                  self.likeImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                                                  self.likeImageView.alpha = 0.0;
                                              }
                                                               completion:^(BOOL finished) {
                                                                   self.likeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                               }];
                                          }];
                     }];
}

- (IBAction)onCommentButtonTapped:(id)sender {

    [self.delegate showSegue:self.cellNumber];
    
}


@end
