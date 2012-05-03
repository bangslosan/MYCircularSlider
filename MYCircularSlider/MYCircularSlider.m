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

//Init and Setup method
- (void)setup;

//Drawing methods
- (CGFloat)sliderRadius;

- (CGPoint)drawPieTrack:(float)track 
                atPoint:(CGPoint)center 
             withRadius:(CGFloat)radius 
              inContext:(CGContextRef)context;

- (CGPoint)drawCircularTrack:(float)track
                     atPoint:(CGPoint)point 
                  withRadius:(CGFloat)radius
                   inContext:(CGContextRef)context;




@property(nonatomic) float oldValue;
@property(nonatomic) CGPoint previousTappedPoint;

@property(nonatomic) double angle;


@end


#pragma mark - Implementation
@implementation MYCircularSlider

#pragma mark - Synthesizers
@synthesize oldValue = _oldValue,
            previousTappedPoint = _previousTappedPoint,
            elapsedTime = _elapsedTime,
            isFilledModeOn = _isFilledModeOn;

@synthesize angle = _angle;

- (void)setElapsedTime:(float)elapsedTime
{
    _elapsedTime = elapsedTime;
    [self setNeedsDisplay];
}

- (void)setIsFilledModeOn:(BOOL)isFilledModeOn
{
    _isFilledModeOn = isFilledModeOn;
    NSLog(@"Filled mode is %i:",_isFilledModeOn);
    [self setNeedsDisplay];
}
//Have a cut off at 55 and 5????
@synthesize value = _value;
- (void)setValue:(float)value
{
    if (value != _value) 
    {
        if (value >= self.maximumValue) 
        {
            value = self.maximumValue;            
        }
        
        if (value < self.minimumValue) 
        {
            value = self.minimumValue;
        }
        _value = value;
        NSLog(@"VALUE:  %f",_value);
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


#pragma mark - Init and Setup Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
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
	//self.filledColor = [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1];
	//self.unfilledColor = [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1];
    self.unfilledColor = [UIColor colorWithRed:197/255.0 green:47/255.0 blue:59/255.0 alpha:1];
	self.filledColor = [UIColor colorWithRed:26/255.0 green:131/255.0 blue:186/255.0 alpha:1];
    
    
    self.isFilledModeOn = YES;
    self.elapsedTime = 0.0;
    
}

#pragma mark - Drawing methods
#define kExtraSpaceRadius 12
#define kLineWidth 6

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint middlePoint;
    middlePoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    middlePoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat radius = [self sliderRadius];
    
    //draw unfilled pie chart
    [self.unfilledColor setFill];
    [self drawPieTrack:self.maximumValue 
               atPoint:middlePoint
            withRadius:radius 
             inContext:context];
    
    //draw part which is filled
    [self.filledColor setFill];
    [self drawPieTrack:self.value 
               atPoint:middlePoint 
            withRadius:radius 
             inContext:context];
    
    //draw elapsed time
    CGContextSetLineWidth(context, kLineWidth);
    [[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] setStroke];
    [self drawCircularTrack:self.elapsedTime 
                    atPoint:middlePoint 
                 withRadius:radius+(kExtraSpaceRadius/2)
                  inContext:context];
    /*
    if (self.isFilledModeOn) 
    {
        [self.filledColor setStroke];
        [self drawCircularTrack:self.elapsedTime 
                        atPoint:middlePoint 
                     withRadius:radius+(kExtraSpaceRadius/2)
                      inContext:context];
    }
    else 
    {
        [self.unfilledColor setStroke];
        [self drawCircularTrack:self.elapsedTime 
                        atPoint:middlePoint 
                     withRadius:radius+(kExtraSpaceRadius/2)
                      inContext:context];
    }
     */
    
}

- (CGFloat)sliderRadius
{
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    radius = radius - kExtraSpaceRadius;
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

- (CGPoint)drawCircularTrack:(float)elapsedTime 
                     atPoint:(CGPoint)center 
                  withRadius:(CGFloat)biggerRadius 
                   inContext:(CGContextRef)context 
{
	
    UIGraphicsPushContext(context);
	
    CGContextBeginPath(context);
	
    //multiplied by 60 because the values are in seconds
    //also has to move every second
	float angleFromTrack = translateValueFromSourceIntervalToDestinationInterval(elapsedTime, self.minimumValue*60, self.maximumValue*60, 0, 2*M_PI);
    
	
    CGFloat startAngle;
    CGFloat endAngle;
    if (self.isFilledModeOn) 
    {
        startAngle = -M_PI_2;   //-90
        endAngle = startAngle + angleFromTrack;
    }
    else 
    {
        //start angle at start of break mode
        
        startAngle = translateValueFromSourceIntervalToDestinationInterval(self.value, self.minimumValue, self.maximumValue, 0, 2*M_PI);
        startAngle = (startAngle-M_PI_2);
         
        endAngle = startAngle + angleFromTrack;
    }

    //endAngle = startAngle + angleFromTrack;
	CGContextAddArc(context, center.x, center.y, biggerRadius, startAngle, endAngle, NO);
	
	CGPoint arcEndPoint = CGContextGetPathCurrentPoint(context);
	
	CGContextStrokePath(context);
	UIGraphicsPopContext();
	
	return arcEndPoint;
}


/** @name Touch management methods */
#pragma mark - Touch management methods

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    //First time value save
    self.oldValue = self.value;
    self.previousTappedPoint = [touch locationInView:self];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event 
{
    CGPoint tapLocation = [touch locationInView:self];
	switch (touch.phase) 
    {
        
        case UITouchPhaseMoved: 
        {
            //Getting the center of the circle
			CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            
            CGFloat angle = angleBetweenThreePoints(sliderCenter, tapLocation, self.previousTappedPoint);
            float newValue;
     
            //for endtracking adjustment save angle
            self.angle = angle;
            
            //Finding direction
            if (angle>0) 
            {
                newValue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
                self.value = self.oldValue+newValue;
            }
            else 
            {
                angle = fabsf(angle);
                newValue = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
                self.value = self.oldValue-newValue;
            }
            
            
			//Saving values to compare with next time
            self.previousTappedPoint = tapLocation;
            self.oldValue = self.value;
                   
            
            
            
			break;
        }
         
            
		default:
			break;
	}
    return [super beginTrackingWithTouch:touch withEvent:event];
}


- (BOOL) isPointInFilledMode:(CGPoint)tapLocation
{
    CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint startPoint = CGPointMake(sliderCenter.x, sliderCenter.y-[self sliderRadius]);
    CGFloat angle = angleBetweenThreePoints(sliderCenter, tapLocation, startPoint);
    if (angle < 0) {
        angle = -angle;
    }
    else {
        angle = 2*M_PI - angle;
    }
    float value = translateValueFromSourceIntervalToDestinationInterval(angle, 
                                                                        0, 2*M_PI, self.minimumValue, self.maximumValue);
    if (self.maximumValue-value<self.value) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
    
}

#define innerButtonRadius 50
- (BOOL) isPointInCircle:(CGPoint)tapLocation
{
    CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint v1 = CGPointMake(tapLocation.x - sliderCenter.x, tapLocation.y - sliderCenter.y);
    float magnitude = sqrtf((v1.x*v1.x)+(v1.y*v1.y));
    if (magnitude<[self sliderRadius] && magnitude>innerButtonRadius) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
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

