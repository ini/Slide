// Copyright © 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>


@interface NSUserDefaults (Color)

- (UIColor *)colorForKey:(NSString *)key;
- (void)setColor:(UIColor *)color forKey:(NSString *)key;

@end


@interface UIColor (Slide)

+ (UIColor *)slideMainColor;
+ (UIColor *)slideBlue;
+ (UIColor *)slideRed;
+ (UIColor *)slideGreen;
+ (UIColor *)slidePink;
+ (UIColor *)slideGrey;
+ (UIColor *)slideDarkGrey;
- (BOOL)isEqualToColor:(UIColor *)otherColor;
- (UIImage *)image;


@end
