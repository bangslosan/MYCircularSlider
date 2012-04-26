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


@end
