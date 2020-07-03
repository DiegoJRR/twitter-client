//
//  TweetCell.m
//  twitter
//
//  Created by Diego de Jesus Ramirez on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender {
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            [self.favButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
            NSLog(@"Successfully favorited");
        }
    }];
}

-(void)refreshData {
    
    self.usernameLabel.text = self.tweet.user.name;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    self.handleLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    
    [self.userImageView setImageWithURL:self.tweet.user.profileImageURL];
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState:UIControlStateNormal];
    [self.favButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
}

@end
