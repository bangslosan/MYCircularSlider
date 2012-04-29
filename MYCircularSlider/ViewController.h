//
//  ViewController.h
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MYCircularSlider.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MYCircularSlider *circularSlider;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;

@property NSDate *startDate;
@property NSDate *stopDate;

@property NSTimeInterval totalTime;
@property NSTimeInterval timeLeft;
@property NSTimeInterval timeElapsed;

@property NSTimer *timer;

@property BOOL isWorkModeOn;
@property BOOL isPaused;
@property BOOL firstPlay;


- (void) fireLocalNotification:(NSTimeInterval)timeLeft;

@end


/////////////
//Put a countdown timer based on the value of the circular
//slider and show it in the button