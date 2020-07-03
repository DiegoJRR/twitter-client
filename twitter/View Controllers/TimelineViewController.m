//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set self as dataSource and delegate for the tableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Added a fixed cell height for now, later this will be changed to auto layout
    self.tableView.rowHeight = 210;
    
    [self getTimeline];
    
    // Instantiate and configure the refreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didTweet:(nonnull Tweet *)tweet {
    // Add the posted tweet to the tweets list and refresh the tableView
    [self.tweets addObject:tweet];
    [self.tableView reloadData];
}   

- (void)getTimeline {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        // Stop the refreshControl regardless of the response
        [self.refreshControl endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    Tweet *tweet = (Tweet *)self.tweets[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    cell.tweet = tweet;
    
    // Set the basic properties for the tweet cell
    if (tweet.favorited) {
        [cell.favButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
    } else {
        [cell.favButton.imageView setImage:[UIImage imageNamed:@"favor-icon"]];
    }
    
    if (tweet.retweeted) {
        [cell.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon-green"]];
    } else {
        [cell.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon"]];
    }
    
    cell.tweetLabel.text = tweet.text;
    cell.usernameLabel.text = tweet.user.name;
    cell.handleLabel.text = [@"@" stringByAppendingString:tweet.user.screenName];
    cell.dateLabel.text = tweet.createdAtString;
    [cell.retweetButton setTitle:[NSString stringWithFormat:@"%i", tweet.retweetCount] forState:UIControlStateNormal];
    [cell.favButton setTitle:[NSString stringWithFormat:@"%i", tweet.favoriteCount] forState:UIControlStateNormal];
    
    // Create the request for the user profile image
    NSURLRequest *request = [NSURLRequest requestWithURL:tweet.user.profileImageURL];
    
    // Set poster to nil to remove the old one (when refreshing) and query for the new one
    cell.userImageView.image = nil;
    
    // Instantiate a weak link to the cell and fade in the image in the request
    __weak TweetCell *weakSelf = cell;
    [weakSelf.userImageView setImageWithURLRequest:request placeholderImage:nil
                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                        
                        // imageResponse will be nil if the image is cached
                        if (imageResponse) {
                            weakSelf.userImageView.alpha = 0.0;
                            weakSelf.userImageView.image = image;
                            
                            //Animate UIImageView back to alpha 1 over 0.3sec
                            [UIView animateWithDuration:0.5 animations:^{
                                weakSelf.userImageView.alpha = 1.0;
                            }];
                        }
                        else {
                            weakSelf.userImageView.image = image;
                        }
                    }
                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                        // do something for the failure condition
                    }];
    
    
    return cell;
}

- (IBAction)logoutAction:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}

@end
