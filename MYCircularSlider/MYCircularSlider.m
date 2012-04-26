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
@end


#pragma mark - Implementation
@implementation MYCircularSlider

#pragma mark - Synthesizers
//Have a cut off at 55 and 5????
@synthesize value = _value;
- (void)setValue:(float)value
{
    
    if (fabsf(_value-value)>5)
    {
        
    }
    else if (value != _value) 
    {
        if (value > self.maximumValue-5) 
        {
            value = self.maximumValue-5;
        }
        if (value < self.minimumValue+5) 
        {
            value = self.minimumValue+5;
        }
        _value = value;
        [self setNeedsDisplay];
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
    return (self.ignoreTouchesExceptOnThumb ? [self isPointInThumb:[touch locationInView:self]] : YES);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint tapLocation = [touch locationInView:self];
	switch (touch.phase) {
		case UITouchPhaseMoved: {
			CGFloat radius = [self sliderRadius];
			CGPoint sliderCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
			CGPoint sliderStartPoint = CGPointMake(sliderCenter.x, sliderCenter.y - radius);
			CGFloat angle = angleBetweenThreePoints(sliderCenter, sliderStartPoint, tapLocation);
			
			if (angle < 0) {
				angle = -angle;
			}
			else {
				angle = 2*M_PI - angle;
			}
			
			self.value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
			break;
		}
		default:
			break;
	}
    return [super beginTrackingWithTouch:touch withEvent:event];
}



@end

#pragma mark - Utility Functions
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum) {
	float a, b, destinationValue;
	
	a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
	b = destinationIntervalMaximum - a*sourceIntervalMaximum;
	
	destinationValue = a*sourceValue + b;
	
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
	return angle;
}

