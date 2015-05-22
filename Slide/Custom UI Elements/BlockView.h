//
//  BlockView.h
//  Slide
//
//  Created by Ini on 7/20/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockView : UIButton

@property int location;
@property int sizeOfGrid;
@property int gridConstant;

- (void)moveBlock:(NSString*) direction;
- (void)setActualLocation:(int)location;
- (int)getLocation;
- (int)getCurrentRow;
- (int)getCurrentCol;

@end
