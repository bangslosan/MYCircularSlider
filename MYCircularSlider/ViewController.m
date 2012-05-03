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
- (void) updateTimeLeftLabel;
- (IBAction)playOrPause:(id)sender;
- (IBAction)sliderValueChanged:(MYCircularSlider *)sender;
- (void) playAfterReset;
- (void)reset;
- (void) calculateTotalTime;
- (void)turnBreakModeOn;
- (void)turnWorkModeOn;

@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@end

@implementation ViewController
@synthesize 
circularSlider = _circularSlider,
innerButton = _innerButton,
timeLeftLabel = _timeLeftLabel,
modeLabel = _modeLabel,
startDate = _startTime,
stopDate = _stopTime,
timeLeft = _timeLeft,
timeElapsed = _timeElapsed,
timer = _timer,
isWorkModeOn = _isWorkModeOn,
isPaused = _isPaused,
firstPlay = _firstPlay,
totalTime = _totalTime,
soundFileObject = _soundFileObject,
soundFileURLRef = _soundFileURLRef;



- (void) setIsWorkModeOn:(BOOL)isWorkModeOn
{
    if (_isWorkModeOn != isWorkModeOn) {
        _isWorkModeOn = isWorkModeOn;
        self.circularSlider.isFilledModeOn = isWorkModeOn;
    }
}


- (void) setTimeElapsed:(NSTimeInterval)timeElapsed
{
    //The value of the elapsed time can never be more than the value
    //of the total time
    if (timeElapsed >= self.totalTime) 
    {
        timeElapsed = self.totalTime;
        
    }
    if (timeElapsed < 0) 
    {
        timeElapsed = 0;
    }
    
    NSLog(@"time Elapsed:%f", timeElapsed);
    _timeElapsed = timeElapsed;
    self.circularSlider.elapsedTime = timeElapsed;
    
}

- (void) setTotalTime:(NSTimeInterval)totalTime
{
    _totalTime = round(totalTime);
    NSLog(@"time total:%f", totalTime);
    [self setTimeElapsed:self.timeElapsed];
    [self updateTimeLeftLabel];
}

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
    self.circularSlider.value = 40;
    

    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];
    
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (__bridge_retained CFURLRef)tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (_soundFileURLRef,&_soundFileObject);
    
    self.firstPlay = YES;
    self.isWorkModeOn = YES;
    //self.timeElapsed = 0;
    [self sliderValueChanged:self.circularSlider];
}

- (void)viewDidUnload
{
    [self setCircularSlider:nil];
    [self setInnerButton:nil];
    [self setTimeLeftLabel:nil];
    [self setModeLabel:nil];
    AudioServicesDisposeSystemSoundID (_soundFileObject);
    CFRelease (_soundFileURLRef);
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
    if (self.isWorkModeOn) 
    {
        //
        //Get int values of circular slider
        //
        
        self.totalTime = self.circularSlider.value*60;
    }
    else 
    {
        self.totalTime = (self.circularSlider.maximumValue-self.circularSlider.value)*60;
    }
}

- (void)turnBreakModeOn
{
   
    self.isWorkModeOn = NO;
     [self calculateTotalTime];
    [self reset];

}

- (void)turnWorkModeOn
{
   
    self.isWorkModeOn = YES;
     [self calculateTotalTime];
    [self reset];
    
}


- (void)reset
{
    self.firstPlay = YES;
    self.timeElapsed = 0;
    self.timeLeft = 0;
    [self calculateTotalTime];
    //Pause
    self.isPaused = NO;
    [self playOrPause:nil];
}

- (void)playAfterReset
{
    //Set start and Stop Time when play pressed
    self.startDate = [NSDate date];

    [self calculateTotalTime];
}


- (IBAction)playOrPause:(id)sender 
{
    if (sender) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(_soundFileObject);
    }
    //Change work mode
    self.isPaused = !self.isPaused;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.modeLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    
    
    if (self.isPaused) 
    {
        [self updateTimeLeftLabel];
        self.modeLabel.text = @"PAUSED";
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
        if (self.isWorkModeOn) 
        {
            self.modeLabel.text = @"WORK";
        }
        else 
        {
            self.modeLabel.text = @"REST";
        }
    }
    
  
}    

- (void)updateTimer
{
    self.timeElapsed = self.timeElapsed + 1.0;

    //Every time timer gets done ..PAUSE
    if (self.timeLeft <= 0) 
    {
        //
        //Notify the user here that the mode is done
        //
        //
        
        self.isWorkModeOn = !self.isWorkModeOn;
        
        [self reset];
        self.isPaused = NO;
        [self playOrPause:nil];
        
    }
    else 
    {
         [self updateTimeLeftLabel];
    }
   
    
    
}

- (void)updateTimeLeftLabel
{
    //Changing the algorithm to see if the 60 sec bug goes away
    /*
     int minutesLeft = floor(self.timeLeft/60);
     int secondsLeft = round(self.timeLeft - minutesLeft * 60);
     */
    self.timeLeft = self.totalTime - self.timeElapsed;
    int timeLeft = (int)self.timeLeft;
    int minutesLeft = (timeLeft/60);
    int secondsLeft = timeLeft % 60;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%i:%02i", minutesLeft, secondsLeft];
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender 
{
    CGPoint tapLocation = [sender locationOfTouch:0 inView:self.circularSlider];
    NSLog(@"%f,%f", tapLocation.x, tapLocation.y);
    if ([self.circularSlider isPointInCircle:tapLocation]) 
    {
        if([self.circularSlider isPointInFilledMode:tapLocation])
        {
            [self turnWorkModeOn];
        }
        else 
        {
            [self turnBreakModeOn];
        }
        
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
