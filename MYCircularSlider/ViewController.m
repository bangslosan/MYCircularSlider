//
//  ViewController.m
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize circularSlider = _circularSlider;
@synthesize middleButton = _middleButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.circularSlider addTarget:self action:@selector(updateProgress:) forControlEvents:UIControlEventValueChanged];
    self.circularSlider.maximumValue = 60;
    self.circularSlider.minimumValue = 1;
    [self updateProgress:self.circularSlider];
}

- (void)viewDidUnload
{
    [self setCircularSlider:nil];
    [self setMiddleButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateProgress:(MYCircularSlider *)sender {
   
    self.circularSlider.value = sender.value;
}

@end
