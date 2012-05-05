//
//  StatisticsViewController.m
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-05-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
- (IBAction)done:(id)sender;

@end

@implementation StatisticsViewController
@synthesize delegate = _delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender 
{
    [self.delegate statisticsViewControllerDidPressDone:self];
}
@end
