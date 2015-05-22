//
//  BlockView.m
//  Slide
//
//  Created by Ini on 7/20/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setActualLocation:(int)location
{
    CGRect newFrame = self.frame;
    int myRow = (int)((location - 1) / [self sizeOfGrid]) + 1;
    int myCol = (location - ((myRow - 1) * [self sizeOfGrid]));
    if (myCol == 0)
    {
        myCol = [self sizeOfGrid];
    }
    newFrame.origin.x = ((myCol - 1) * self.gridConstant) + 11;
    newFrame.origin.y = ((myRow - 1) * self.gridConstant) + 11;
    [UIView animateWithDuration:.6 animations:^{self.frame = newFrame;}];
}

- (int)getLocation
{
    int myRow = (int)((self.frame.origin.y - 11) / self.gridConstant) + 1;
    int myCol = (int)((self.frame.origin.x - 11) / self.gridConstant) + 1;
    return ((myRow - 1) * self.sizeOfGrid) + myCol;
}

- (int)getCurrentRow
{
    return (int)((self.location - 1) / [self sizeOfGrid]) + 1;
}

- (int)getCurrentCol
{
    int myCol = (self.location - ((self.getCurrentRow - 1) * [self sizeOfGrid]));
    if (myCol == 0)
    {
        myCol = [self sizeOfGrid];
    }
    return myCol;
}

- (void)moveBlock:(NSString*) direction
{
    CGRect newFrame = self.frame;
    if ([direction isEqualToString:@"N"])
    {
        newFrame.origin.y -= self.gridConstant;
    }
    else if ([direction isEqualToString:@"S"])
    {
        newFrame.origin.y += self.gridConstant;
    }
    else if ([direction isEqualToString:@"E"])
    {
        newFrame.origin.x += self.gridConstant;
    }
    else if ([direction isEqualToString:@"W"])
    {
        newFrame.origin.x -= self.gridConstant;
    }
    
    [UIView animateWithDuration:0.12 animations:^{self.frame = newFrame;}];
}
@end
