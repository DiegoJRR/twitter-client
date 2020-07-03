//
//  DetailsViewController.h
//  twitter
//
//  Created by Diego de Jesus Ramirez on 02/07/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
