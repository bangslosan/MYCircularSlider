//
//  ViewController.h
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MYCircularSlider.h"

@interface ViewController : UIViewController

@property (weak, nonatomic)IBOutlet MYCircularSlider *circularSlider;
@property (strong, nonatomic)IBOutlet UIButton *innerButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *modeLabel;

@property NSDate *startDate;
@property NSDate *stopDate;

@property (nonatomic)NSTimeInterval totalTime;
@property (nonatomic)NSTimeInterval timeLeft;
@property (nonatomic)NSTimeInterval timeElapsed;

@property NSTimer *timer;

@property (nonatomic) BOOL isWorkModeOn;
@property BOOL isPaused;
@property BOOL firstPlay;

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender;

- (void) fireLocalNotification:(NSTimeInterval)timeLeft;

@end

