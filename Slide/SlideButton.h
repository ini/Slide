//  Copyright © 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIColor+Slide.h"

typedef enum SlideButtonHighlightStyle : NSUInteger {
    SlideButtonHighlightStyleText,
    SlideButtonHighlightStyleBackground
} SlideButtonHighlightStyle;

@interface SlideButton : UIButton

@property UIView *highlightMask;
@property SlideButtonHighlightStyle highlightStyle;

@end
