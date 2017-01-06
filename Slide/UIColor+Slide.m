// Copyright © 2016 Insi. All rights reserved.

#import "UIColor+Slide.h"

@implementation NSUserDefaults (Color)

- (UIColor *)colorForKey:(NSString *)key {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}
    
- (void)setColor:(UIColor *)color forKey:(NSString *)key {
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:key];
}

@end


@implementation UIColor (Slide)

+ (UIColor *)slideMainColor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults colorForKey:@"mainColor"]) {
        return [defaults colorForKey:@"mainColor"];
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

+ (UIColor *)slideBlack {
    return [UIColor colorWithRed:36.0/255.0 green:42.0/255.0 blue:44.0/255.0 alpha:1.0];
}

+ (UIColor *)slideGrey {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}

+ (UIColor *)slideDarkGrey {
    return [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0];
}

- (BOOL)isEqualToColor:(UIColor *)color {
    CGFloat s_red = 0.0, s_green = 0.0, s_blue = 0.0, s_alpha = 0.0;
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    [self getRed:&s_red green:&s_green blue:&s_blue alpha:&s_alpha];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return ((int)(s_red * 1000) == (int)(red * 1000) && (int)(s_green * 1000) == (int)(green * 1000) &&
            (int)(s_blue * 1000) == (int)(blue * 1000) && (int)(s_alpha * 1000) == (int)(alpha * 1000));
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
