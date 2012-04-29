//
//  ViewController.m
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void) updateTimer;
- (IBAction)playOrPause:(id)sender;
- (IBAction)sliderValueChanged:(MYCircularSlider *)sender;
- (void) playAfterReset;
- (IBAction)reset:(id)sender;
- (void) calculateTotalTime;
- (IBAction)turnBreakModeOn:(id)sender;
- (IBAction)turnWorkModeOn:(id)sender;



@property (strong, nonatomic) IBOutlet UILabel *temporaryLabel;

@end

@implementation ViewController
@synthesize temporaryLabel = _temporaryLabel;
@synthesize circularSlider = _circularSlider;
@synthesize middleButton = _middleButton;
@synthesize startDate = _startTime;
@synthesize stopDate = _stopTime;
@synthesize timeLeft = _timeLeft;
@synthesize timeElapsed = _timeElapsed;
@synthesize timer = _timer;
@synthesize isWorkModeOn = _isWorkModeOn;
@synthesize isPaused = _isPaused;
@synthesize firstPlay = _firstPlay;
@synthesize totalTime = _totalTime;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    //Save things not related to the view somewhere else like in a plist
    //
    NSLog(@"View Did Load");
    //Target-action
    //[self.circularSlider addTarget:self 
    //                        action:@selector(sliderValueChanged:)
    //              forControlEvents:UIControlEventValueChanged];
    self.circularSlider.maximumValue = 60;
    self.circularSlider.minimumValue = 0;
    self.circularSlider.value = 4;
    self.circularSlider.value = 8;
    self.circularSlider.value = 12;
    self.firstPlay = YES;
    self.isWorkModeOn = YES;
    //self.timeElapsed = 0;
    [self sliderValueChanged:self.circularSlider];
}

- (void)viewDidUnload
{
    [self setCircularSlider:nil];
    [self setMiddleButton:nil];
    [self setTemporaryLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Value changed
- (IBAction)sliderValueChanged:(MYCircularSlider *)sender 
{
   
    self.circularSlider.value = sender.value;
    //whenever value changed..PAUSE the timer
    self.isPaused = NO;
    [self playOrPause:nil];
    //Calculate all the times
    //self.totalTime = self.circularSlider.value*60;
    [self calculateTotalTime];
    
}

- (void) calculateTotalTime
{
    if (self.isWorkModeOn) {
        //
        //Get int values of circular slider
        //
        
        self.totalTime = self.circularSlider.value*60;
    }
    else {
        self.totalTime = (self.circularSlider.maximumValue-self.circularSlider.value)*60;
    }
}

- (IBAction)turnBreakModeOn:(id)sender 
{
    //if break mode is already on
    //do nothing
    if (!self.isWorkModeOn) 
    {
        
    }
    //else turn break mode on
    //and reset
    else 
    {
        self.isWorkModeOn = NO;
        [self reset:nil];

    }
}

- (IBAction)turnWorkModeOn:(id)sender 
{
    //if work mode is already on
    //do nothing
    if (self.isWorkModeOn) 
    {
        
    }
    //else turn work mode on
    //and reset
    else 
    {
        self.isWorkModeOn = YES;
        [self reset:nil];
        
    }    
}

- (IBAction)reset:(id)sender
{
    if (sender) {
        self.isWorkModeOn = YES;
    }
    self.firstPlay = YES;
    self.timeElapsed = 0;
    self.timeLeft = 0;
    //Pause
    self.isPaused = NO;
    [self playOrPause:nil];
}

- (void)playAfterReset
{
    //Set start and Stop Time when play pressed
    self.startDate = [NSDate date];
    //self.totalTime = self.circularSlider.value*60;
    [self calculateTotalTime];
}


- (IBAction)playOrPause:(id)sender 
{
    //Change work mode
    self.isPaused = !self.isPaused;
    
    if (self.isPaused) 
    {
        self.middleButton.titleLabel.text = @"Paused";
        //stop the timer
        [self.timer invalidate];
        self.timer = nil;
    }
    else 
    {
        //if first play, set start time 
        if (self.firstPlay) 
        {
            [self playAfterReset];
            self.firstPlay = NO;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        
    }
    
  
}    

- (void)updateTimer
{
    self.timeElapsed = self.timeElapsed + 1.0;
    self.temporaryLabel.text = [NSString stringWithFormat:@"%f",self.timeElapsed];
    self.timeLeft = self.totalTime - self.timeElapsed;
    //self.timeLeft = [self.stopTime timeIntervalSinceDate:[NSDate date]];
    //Every time timer gets done ..PAUSE
    if (self.timeLeft <= 0) 
    {
        //
        //Notify the user here that the mode is done
        //
        //
        
        self.isWorkModeOn = !self.isWorkModeOn;
        
        [self reset:nil];
        self.isPaused = NO;
        [self playOrPause:nil];
        
    }
    else 
    {
        int minutesLeft = floor(self.timeLeft/60);
        int secondsLeft = round(self.timeLeft - minutesLeft * 60);
        
        self.middleButton.titleLabel.text = [NSString stringWithFormat:@"%i:%02i", minutesLeft, secondsLeft];
    }
    
}

- (void)fireLocalNotification:(NSTimeInterval)timeLeft
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if ([oldNotifications count] > 0) {
        [app cancelAllLocalNotifications];
    }
    
    self.stopDate = [NSDate dateWithTimeIntervalSinceNow:timeLeft];
    //Create new one
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        notification.fireDate = self.stopDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.soundName = @"sms-received.wav";
        notification.alertAction = @"Ok";
        if (self.isWorkModeOn) 
        {
            notification.alertBody = @"Done!\nSwitch to Play Mode?"; 
        }
        else 
        {
            notification.alertBody = @"Done!\nStart working again?";
        }
       [app scheduleLocalNotification:notification];
        NSLog(@"%@",self.stopDate);
    }
}


@end
