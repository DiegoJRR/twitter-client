//
//  DetailsViewController.m
//  twitter
//
//  Created by Diego de Jesus Ramirez on 02/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
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

- (IBAction)didTapFavoriteButton:(id)sender {
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            if (self.tweet.favorited) {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                
                [self.favButton.imageView setImage:[UIImage imageNamed:@"favor-icon"]];
                
            } else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                
                [self.favButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
            }
        }
    }];
    
    [self refreshData];
}


- (IBAction)didTapRetweetButton:(id)sender {
    
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        
        } else {
            if (self.tweet.retweeted) {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                
                [self.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon"]];
                
            } else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                
                [self.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon-green"]];
            }
        }
        
      }];
    
    [self refreshData];
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
