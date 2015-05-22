//
//  MoveController.h
//  Slide
//
//  Created by Ini on 7/19/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveController : NSObject
@property (nonatomic) int SIZE;
@property (strong, nonatomic) NSMutableArray *emptyLocation;
@property (strong, nonatomic) NSMutableArray *blocksToMove;
@property int moveCount;

-(void)getMove:(int)locationTapped;
-(NSArray *)getScrambledGrid;
-(BOOL)checkDirection:(UISwipeGestureRecognizerDirection)directionSwiped andInt:(int)locationTapped;

@end
