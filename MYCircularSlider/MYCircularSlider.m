//
//  MYCircularSlider.m
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 Sehaj Chawla. All rights reserved.
//

#import "MYCircularSlider.h"

#pragma mark - Private methods
@interface MYCircularSlider()

//Do I need this????
@property(nonatomic) CGPoint thumbCenterPoint;

//Init and Setup method
- (void)setup;

//Thumb managment method????
- (BOOL)isPointInThumb:(CGPoint)point;

//Drawing methods
- (CGFloat)sliderRadius;

- (void) drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint 
                inContext:(CGContextRef)context; //do I need this?

- (CGPoint)drawPieTrack:(float)track 
                atPoint:(CGPoint)center 
             withRadius:(CGFloat)radius 
              inContext:(CGContextRef)context;

@property(nonatomic) float oldValue;
@property(nonatomic) float newValue;
@property(nonatomic) float valueAtTappedPoint;
@property(nonatomic) BOOL maxReached;
@property(nonatomic) BOOL minReached;
@property(nonatomic) CGPoint tappedPoint;
@property(nonatomic) CGPoint tappedPreviousPoint;
@property(nonatomic) float signOfAngle;

@end


#pragma mark - Implementation
@implementation MYCircularSlider

#pragma mark - Synthesizers
@synthesize oldValue;
@synthesize newValue;
@synthesize valueAtTappedPoint;
@synthesize maxReached, minReached;
@synthesize tappedPoint, tappedPreviousPoint;
@synthesize signOfAngle;

//Have a cut off at 55 and 5????
@synthesize value = _value;
- (void)setValue:(float)value
{
    
    /*if (fabsf(_value-value))
    {
        
    }
    else */if (value != _value) 
    {
        
        if (value >= self.maximumValue-5) 
        {
            value = self.maximumValue-5;
            //Animate view and cancel all touches
            [self cancelTrackingWithEvent:nil];
            
        }
        
        if (value < self.minimumValue+5) 
        {
            value = self.minimumValue+5;
            //Animate view and cancel all touches
            [self cancelTrackingWithEvent:nil];
        }
        _value = value;
        [self setNeedsDisplay];
        
        //For target action
        //whenever value is changed
        //this controller sends this action
        //to whoever the target is
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@synthesize minimumValue = _minimumValue;
- (void)setMinimumValue:(float)minimumValue
{
    if (minimumValue != _minimumValue) 
    {
		_minimumValue = minimumValue;
		if (self.maximumValue < self.minimumValue)	
        {
            self.maximumValue = self.minimumValue; 
        }
		if (self.value < self.minimumValue)		
        {
            self.value = self.minimumValue; 
        }
	}
}

@synthesize maximumValue = _maximumValue;
- (void)setMaximumValue:(float)maximumValue 
{
	if (maximumValue != _maximumValue) 
    {
		_maximumValue = maximumValue;
		if (self.minimumValue > self.maximumValue)	
        { 
            self.minimumValue = self.maximumValue; 
        }
		if (self.value > self.maximumValue)			
        {
            self.value = self.maximumValue; 
        }
	}
}

@synthesize filledColor = _filledColor;
- (void)setFilledColor:(UIColor *)filledColor
{
	if (![filledColor isEqual:_filledColor])
    {
		_filledColor = filledColor;
		[self setNeedsDisplay];
	}
}

@synthesize unfilledColor = _unfilledColor;
- (void)setUnfilledColor:(UIColor *)unfilledColor 
{
	if (![unfilledColor isEqual:_unfilledColor]) 
    {
		_unfilledColor = unfilledColor;
		[self setNeedsDisplay];
	}
}

@synthesize thumbTintColor = _thumbTintColor;
- (void)setThumbTintColor:(UIColor *)thumbTintColor 
{
	if (![thumbTintColor isEqual:_thumbTintColor]) 
    {
		_thumbTintColor = thumbTintColor;
		[self setNeedsDisplay];
	}
}

@synthesize thumbImage = _thumbImage;
- (void)setThumbImage:(UIImage *)thumbImage 
{
	if (![thumbImage isEqual:_thumbImage]) 
    {
		_thumbImage = thumbImage;
		[self setNeedsDisplay];
	}
}

@synthesize ignoreTouchesExceptOnThumb = _ignoreTouchesExceptOnThumb;
@synthesize thumbCenterPoint = _thumbCenterPoint;



#pragma mark - Init and Setup Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
	[self setup];
}

- (void)setup {
	self.value = 45.0;
	self.minimumValue = 0.0;
	self.maximumValue = 60.0;
	self.filledColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
	self.unfilledColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
	self.thumbTintColor = [UIColor clearColor];
	self.thumbCenterPoint = CGPointZero;
    //self.thumbImage??
}

#pragma mark - Drawing methods
#define kThumbRadius 12.0

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint middlePoint;
    middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    //CGContextSetLineWidth(context, kLineWidth);
    CGFloat radius = [self sliderRadius];
    
    [self.unfilledColor setFill];
    [self drawPieTrack:self.maximumValue 
               atPoint:middlePoint
            withRadius:radius 
             inContext:context];
    /*
    [self.unfilledColor setStroke];
    [self drawCircularTrack:self.maximumValue 
                    atPoint:middlePoint 
                 withRadius:radius 
                  inContext:context];
     */
    [self.filledColor setFill];
    self.thumbCenterPoint = [self drawPieTrack:self.value 
                                       atPoint:middlePoint 
                                    withRadius:radius 
                                     inContext:context];
    
    [self drawThumbAtPoint:self.thumbCenterPoint inContext:context];
    
    
}

- (CGFloat)sliderRadius
{
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    radius = radius - kThumbRadius;
    return radius;
}

- (CGPoint)drawPieTrack:(float)track 
                atPoint:(CGPoint)center 
             withRadius:(CGFloat)radius 
              inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    
    float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(track, self.minimumValue, self.maximumValue, 0, 2*M_PI);
    
    CGFloat startAngle = -M_PI_2;   //-90
    CGFloat endAngle = startAngle + angleFromTrack;
    CGContextMoveToPoint(context, center.x, center.y);
	CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}

 - (void)drawThumbAtPoint:(CGPoint)sliderButtonCenterPoint 
 inContext:(CGContextRef)context
 {
     //get slider button center point first
     if (self.thumbImage) 
     {
         [self.thumbImage drawAtPoint:(CGPoint){
             .x = sliderButtonCenterPoint.x - (self.thumbImage.size.width/2), 
             .y = sliderButtonCenterPoint.y - (self.thumbImage.size.height/2)
            }
          ];
         
         }
 }




//
//
//   NEXT JOB
// Instead of the thumb..make the line controller

/** @name Thumb management methods */
#pragma mark - Thumb management methods
- (BOOL)isPointInThumb:(CGPoint)point {
	CGRect thumbTouchRect = CGRectMake(self.thumbCenterPoint.x - kThumbRadius, self.thumbCenterPoint.y - kThumbRadius, kThumbRadius*2, kThumbRadius*2);
	return CGRectContainsPoint(thumbTouchRect, point);
}


/** @name Touch management methods */
#pragma mark - Touch management methods

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    self.oldValue = self.value;
    self.tappedPoint = [touch locationInView:self];
    
    
    //self.tappedPreviousPoint = self.tappedPoint;
    /*
    //get the value where the point started
    //Getting the radius of the circle
    CGFloat radius = [self sliderRadius];
    //Getting the center of the circle
    CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //Start at the top of the circle
    CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - radius);
    //Getting the smallest angle between them(to draw the arc)
    //this angle should be between
    CGFloat angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(self.value, self.minimumValue, self.maximumValue, 0, 2*M_PI);
    
    
    //CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
    
    //if angle is negative, then it is a clockwise angle
    //so real angle is the positive value of it
    if (angle < 0) 
    {
        angle = -angle;
    }
    //if angle is positive, then it is a counter-clockwise angle
    //so get the real angle. 360-x
    else 
    {
        angle = 2*M_PI - angle;
    }
    //Get the value of the slider
    //Whenever value is set.it redraws on the screen
    //and an action to the its target is sent
    self.valueAtTappedPoint = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
    return (self.ignoreTouchesExceptOnThumb ? [self isPointInThumb:[touch locationInView:self]] : YES);
     */
    return YES;
}

//WHEN I Calculate the angle
//it shouldn't be between the point where I touched..tap location
//it should take into account my original slider value
//and just add
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint tapLocation = [touch locationInView:self];
	switch (touch.phase) 
    {
		case UITouchPhaseMoved: 
        {
            //Getting the radius of the circle
			//CGFloat radius = [self sliderRadius];
            //Getting the center of the circle
			CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            //Start at the top of the circle
			//CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - radius);
            //Getting the smallest angle between them(to draw the arc)
			//CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
            
            CGFloat angle = angleBetweenThreePoints(sliderCenter, tapLocation, self.tappedPoint);
            //self.signOfAngle = angleBetweenThreePoints(sliderCenter, tapLocation, self.tappedPreviousPoint);
            
            NSLog(@"%f",angle);
            
            
            /*
             //if angle is negative, then it is a clockwise angle
             //so real angle is the positive value of it
             if (angle < 0) 
             {
             angle = -angle;
             }
             //if angle is positive, then it is a counter-clockwise angle
             //so get the real angle. 360-x
             else 
             {
             angle = 2*M_PI - angle;
             }
            */
            
            //if I'm going in the other direction it should be -
            if (angle>0) 
            {
                self.newValue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
                self.value = self.oldValue+self.newValue;
            }
            else 
            {
                angle = fabsf(angle);
                self.newValue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
                self.value = self.oldValue-self.newValue;
            }
                        
            
			//Get the value of the slider
            //Whenever value is set.it redraws on the screen
            //and an action to the its target is sent
            
          
/*
            
            
			//new value should be able to go above 360
            self.newValue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
            
            
            self.value = self.oldValue+(self.newValue-self.valueAtTappedPoint);
            float angle = self.+(self.
             */
            //self.tappedPreviousPoint = tapLocation;
            self.tappedPoint = tapLocation;
            self.oldValue = self.value;
			break;
		
        }
            
		default:
			break;
	}
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
}

//if value reaches less than 5 cancel tracking
//
-(void) cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
}

@end

#pragma mark - Utility Functions
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, 
                                                            float sourceIntervalMinimum, 
                                                            float sourceIntervalMaximum, 
                                                            float destinationIntervalMinimum,
                                                            float destinationIntervalMaximum) 
{
	float m, b, destinationValue;
	//m is the slope(y2-y1/x2-x1) 
	m = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
    //b is the y-intercept
	b = destinationIntervalMaximum - m*sourceIntervalMaximum;
	
    //
	destinationValue = m*sourceValue + b;
	
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) 
{
    //Get the two vectors
    CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	//Calculate the angle between the two vectors
    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
    
	return angle;
}

