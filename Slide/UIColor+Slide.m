// Copyright © 2016 Insi. All rights reserved.

#import "UIColor+Slide.h"

@implementation UIColor (Slide)

+ (UIColor *)slideMainColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"mainColor"]) {
        return [defaults objectForKey:@"mainColor"];
    }
    return UIColor.slideBlue;
}

+ (UIColor *)slideRed {
    return [UIColor colorWithRed:219.0/255.0 green:69.0/255.0 blue:55.0/255.0 alpha:1.0];
}

+ (UIColor *)slideBlue {
    return [UIColor colorWithRed:53.0/255.0 green:109.0/255.0 blue:168.0/255.0 alpha:1.0];
}

+ (UIColor *)slideGreen {
    return [UIColor colorWithRed:37.0/255.0 green:114.0/255.0 blue:71.0/255.0 alpha:1.0];
}

+ (UIColor *)slidePink {
    return [UIColor colorWithRed:252.0/255.0 green:23.0/255.0 blue:130.0/255.0 alpha:1.0];
}


+ (UIColor *)slideGrey {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}

+ (UIColor *)slideDarkGrey {
    return [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
}

- (UIImage *)image {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
