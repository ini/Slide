//
//  MoveController.m
//  Slide
//
//  Created by Ini on 7/19/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import "MoveController.h"

@implementation MoveController

-(BOOL)checkDirection:(UISwipeGestureRecognizerDirection)directionSwiped andInt:(int)locationTapped
{
    int myRow = ((locationTapped - 1)/ self.SIZE) + 1;
    int myCol = (locationTapped - ((myRow - 1) * self.SIZE));
    if (myCol == 0)
    {
        myCol = self.SIZE;
    }
    int emptyRow = [self.emptyLocation[0] intValue];
    int emptyCol = [self.emptyLocation[1] intValue];
    
    if (myRow == emptyRow)
    {
        if (myCol - emptyCol > 0)
        {
            return directionSwiped == UISwipeGestureRecognizerDirectionLeft;
        }
        else if (myCol - emptyCol < 0)
        {
            return directionSwiped == UISwipeGestureRecognizerDirectionRight;
        }
    }
    else if (myCol == emptyCol)
    {
        if (myRow - emptyRow > 0)
        {
            return directionSwiped == UISwipeGestureRecognizerDirectionUp;
        }
        else if (myRow - emptyRow < 0)
        {
            return directionSwiped == UISwipeGestureRecognizerDirectionDown;
        }
    }
    
    return NO;
}

-(void)getMove:(int)locationTapped
{
    [self.blocksToMove removeAllObjects];
    int myRow = ((locationTapped - 1)/ self.SIZE) + 1;
    int myCol = (locationTapped - ((myRow - 1) * self.SIZE));
    if (myCol == 0)
    {
        myCol = self.SIZE;
    }
    int emptyRow = [self.emptyLocation[0] intValue];
    int emptyCol = [self.emptyLocation[1] intValue];
    
    if (myRow == emptyRow)
    {
        if (myCol - emptyCol > 0)
        {
            for (int i = 0; i < myCol - emptyCol; i++)
            {
                [self.blocksToMove addObject:@(locationTapped - i)];
            }
            [self.blocksToMove addObject:@"W"];
        }
        else if (myCol - emptyCol < 0)
        {
            for (int j = 0; j < emptyCol - myCol; j++)
            {
                [self.blocksToMove addObject:@(locationTapped + j)];
            }
            [self.blocksToMove addObject:@"E"];
        }
    }
    else if (myCol == emptyCol)
    {
        if (myRow - emptyRow > 0)
        {
            for (int k = 0; k < myRow - emptyRow; k++)
            {
                [self.blocksToMove addObject:@(locationTapped - k * self.SIZE)];
            }
            [self.blocksToMove addObject:@"N"];
        }
        else if (myRow - emptyRow < 0)
        {
            for (int l = 0; l < emptyRow - myRow; l++)
            {
                [self.blocksToMove addObject:@(locationTapped + l * self.SIZE)];
            }
            [self.blocksToMove addObject:@"S"];
        }
    }
    [self.emptyLocation removeAllObjects];
    [self.emptyLocation addObject:@(myRow)];
    [self.emptyLocation addObject:@(myCol)];
    self.moveCount++;
}

-(NSArray *)getScrambledGrid
{
    NSMutableArray *grid;
    
    if (self.SIZE == 3)
    {
        grid = [[NSMutableArray alloc] initWithObjects: @9, @1, @2, @3, @4, @5, @6, @7, @8, nil];
    }
    else if(self.SIZE == 4)
    {
        grid = [[NSMutableArray alloc] initWithObjects: @16, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, nil];
    }
    else if (self.SIZE == 5)
    {
        grid = [[NSMutableArray alloc] initWithObjects: @25, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, nil];
    }
    int revert = 0;
    int next = 0;
    int cant1 = 2;
    int cant2 = 3;
    for (int i = 0; i < 100 * self.SIZE; i++)
    {
        next = revert;
        while (next == revert || next == cant1 || next == cant2)
        {
            next = (arc4random() % 4) + 1;
        }
            if (next == 1)
        {
            int prev = (int)[grid indexOfObject:@([[grid objectAtIndex: 0] intValue] - self.SIZE)];
            [grid exchangeObjectAtIndex:0 withObjectAtIndex:prev];
            revert = 3;
        }
        if (next == 2)
        {
            int prev = (int)[grid indexOfObject:@([[grid objectAtIndex: 0] intValue] + 1)];
            [grid exchangeObjectAtIndex:0 withObjectAtIndex:prev];
            revert = 4;
        }
        if (next == 3)
        {
            int prev = (int)[grid indexOfObject:@([[grid objectAtIndex: 0] intValue] + self.SIZE)];
            [grid exchangeObjectAtIndex:0 withObjectAtIndex:prev];
            revert = 1;
        }
        if (next == 4)
        {
            int prev = (int)[grid indexOfObject:@([[grid objectAtIndex: 0] intValue] - 1)];
            [grid exchangeObjectAtIndex:0 withObjectAtIndex:prev];
            revert = 2;
        }
        
        if ([[grid objectAtIndex:0] intValue] <= self.SIZE)
        {
            cant1 = 1;
        }
        else if ([[grid objectAtIndex:0] intValue] >= self.SIZE * (self.SIZE - 1) + 1)
        {
            cant1 = 3;
        }
        else
        {
            cant1 = 0;
        }
        if ([[grid objectAtIndex:0] intValue] % self.SIZE == 1)
        {
            cant2 = 4;
        }
        else if ([[grid objectAtIndex:0] intValue] % self.SIZE == 0)
        {
            cant2 = 2;
        }
        else
        {
            cant2 = 0;
        }
    }

    return grid;
}

@end
