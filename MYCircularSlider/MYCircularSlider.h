//
//  MYCircularSlider.h
//  MYCircularSlider
//
//  Created by Sehaj Chawla on 12-04-24.
//  Copyright (c) 2012 Sehaj Chawla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYCircularSlider : UIControl


//Values - current, minimum, maximum
@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;

//Colors
@property(nonatomic) UIColor *filledColor;
@property(nonatomic) UIColor *unfilledColor;
@property(nonatomic) UIColor *thumbTintColor;
@property(nonatomic, strong) UIImage *thumbImage;

@property (readwrite) BOOL ignoreTouchesExceptOnThumb;

@end

#pragma mark - Utility Functions
/**
 * Translate a value in a source interval to a destination interval
 * @param sourceValue					The source value to translate
 * @param sourceIntervalMinimum			The minimum value in the source interval
 * @param sourceIntervalMaximum			The maximum value in the source interval
 * @param destinationIntervalMinimum	The minimum value in the destination interval
 * @param destinationIntervalMaximum	The maximum value in the destination interval
 * @return	The value in the destination interval
 *
 * This function uses the linear function method, a.k.a. resolves the y=ax+b equation where y is a destination value and x a source value
 */
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, 
                                                            float sourceIntervalMinimum, 
                                                            float sourceIntervalMaximum, 
                                                            float destinationIntervalMinimum, 
                                                            float destinationIntervalMaximum);
/**
 * Returns the smallest angle between three points, one of them clearly indicated as the "junction point" or "center point".
 * @param centerPoint	The "center point" or "junction point"
 * @param p1			The first point, member of the [centerPoint p1] segment
 * @param p2			The second point, member of the [centerPoint p2] segment
 * @return				The angle between those two segments
 
 * This function uses the properties of the triangle and arctan (atan2f) function to calculate the angle.
 */
CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2);