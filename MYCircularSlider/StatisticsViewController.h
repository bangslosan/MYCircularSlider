//
//  StatisticsViewController.h
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatisticsViewController;
@protocol StatisticsViewControllerDelegate <NSObject>

-(void)statisticsViewControllerDidPressDone:(StatisticsViewController *)controller;

@end


@interface StatisticsViewController : UIViewController

@property(nonatomic, weak) id <StatisticsViewControllerDelegate>delegate;

@end

