//  Copyright (c) 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>
#import "GCHelper.h"
#import "Masonry.h"
#import "UIColor+Slide.h"


@protocol GridViewDelegate

@required

- (void)moveMade;
- (void)gridSolved;

@end


@interface GridView : UIView

@property id <GridViewDelegate> delegate;
@property int height;
@property int width;

- (id)initWithHeight:(int)height andWidth:(int)width;
- (void)scramble;

@end
