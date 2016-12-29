//  Copyright (c) 2016 Insi. All rights reserved.

#import "GridView.h"

CGFloat const blockInset = 10.0f;


@interface BlockView : UIView

- (id)initWithNumber:(int)num;

@property UILabel *numberLabel;
@property int blockNumber;
@property int row;
@property int col;

@end


@implementation BlockView

- (id)initWithNumber:(int)num {
    self = [super init];
    
    self->_blockNumber = num;
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    
    self.numberLabel = [UILabel new];
    self.numberLabel.text = [NSString stringWithFormat:@"%d", num];
    self.numberLabel.textColor = UIColor.slideBlue;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numberLabel];
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.numberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.lessThanOrEqualTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateConstraints];
    self.numberLabel.font =
        [UIFont fontWithName:@"HelveticaNeue-Thin" size:fmin(31.0, self.frame.size.height - 10.0)];
}

@end


@interface GridView () <UIGestureRecognizerDelegate>

@property float blockSize;
@property NSMutableArray *grid;
@property NSArray *blocks;
@property int emptySquareRow;
@property int emptySquareCol;

@end


@implementation GridView

- (id)initWithHeight:(int)height andWidth:(int)width {
    self = [super init];
    
    if (self) {
        self.backgroundColor = UIColor.slideBlue;
        self.layer.cornerRadius = 10.0;
        self.height = height;
        self.width = width;
        self.emptySquareRow = height - 1;
        self.emptySquareCol = width - 1;
        
        NSMutableArray *blocks = [NSMutableArray array];
        for (int r = 0; r < self.height; r++) {
            for (int c = 0; c < self.width; c++) {
                if (r == self.height - 1 && c == self.width - 1) continue;
                int blockNum = r * self.width + c + 1;
                BlockView *block = [[BlockView alloc] initWithNumber:blockNum];
                [blocks addObject:block];
            }
        }
        
        self.blocks = [blocks copy];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gridTapped:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UISwipeGestureRecognizer *leftSwipe =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gridSwiped:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipe.cancelsTouchesInView = NO;
        [self addGestureRecognizer:leftSwipe];
        
        UISwipeGestureRecognizer *rightSwipe =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gridSwiped:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        rightSwipe.cancelsTouchesInView = NO;
        [self addGestureRecognizer:rightSwipe];
        
        UISwipeGestureRecognizer *upSwipe =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gridSwiped:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
        upSwipe.cancelsTouchesInView = NO;
        [self addGestureRecognizer:upSwipe];
        
        UISwipeGestureRecognizer *downSwipe =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gridSwiped:)];
        downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
        downSwipe.cancelsTouchesInView = NO;
        [self addGestureRecognizer:downSwipe];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.grid) {
        // Add blocks to the grid if it hasn't already been filled
        [self resetGrid];
        self.blockSize = (self.superview.frame.size.width - blockInset) / fmax(self.height, self.width) - blockInset;
        
        for (int r = 0; r < self.height; r++) {
            for (int c = 0; c < self.width; c++) {
                CGRect blockFrame = [self blockFrameFromRow:r andCol:c];
                
                if (!(r == self.height - 1 && c == self.width - 1)) {
                    BlockView *block = self.blocks[r * self.width + c];
                    block.row = r;
                    block.col = c;
                    block.frame = blockFrame;
                    [self addSubview:block];
                }
                
                // Add grey placeholder view for all possible block spots in the grid
                UIView *blockPlaceholder = [[UIView alloc] initWithFrame:blockFrame];
                blockPlaceholder.backgroundColor = UIColor.slideDarkGrey;
                blockPlaceholder.layer.cornerRadius = 3.0;
                [self addSubview:blockPlaceholder];
                [self sendSubviewToBack:blockPlaceholder];
            }
        }
    }
}

- (void)resetGrid {
    self.grid = [NSMutableArray array];
    for (int r = 0; r < self.height; r++) {
        NSMutableArray *row = [NSMutableArray array];
        for (int c = 0; c < self.width; c++) {
            if (r == self.height - 1 && c == self.width - 1) {
                // Add a null object instead of a block to the grid's 2D-array for the last spot in the grid
                [row addObject:[NSNull null]];
            }
            else {
                [row addObject:self.blocks[r * self.width + c]];
            }
        }
        [self.grid addObject:row];
    }
}

#pragma mark - Event Handling

- (void)gridTapped:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationOfTouch:0 inView:self];
    int row = (int)((touchPoint.y - blockInset) / (self.blockSize + blockInset)) % self.height;
    int col = (int)((touchPoint.x - blockInset) / (self.blockSize + blockInset)) % self.width;
    [self tapLocationAtRow:row andCol:col];
}

- (void)gridSwiped:(UISwipeGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationOfTouch:0 inView:self];
    int row = (int)((touchPoint.y - blockInset) / (self.blockSize + blockInset)) % self.height;
    int col = (int)((touchPoint.x - blockInset) / (self.blockSize + blockInset)) % self.width;
        
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (col == self.emptySquareCol) col -= 1;
        if (self.emptySquareCol != 0) row = self.emptySquareRow;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (col == self.emptySquareCol) col += 1;
        if (self.emptySquareCol != self.width - 1) row = self.emptySquareRow;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        if (row == self.emptySquareRow) row -= 1;
        if (self.emptySquareRow != 0) col = self.emptySquareCol;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        if (row == self.emptySquareRow) row += 1;
        if (self.emptySquareRow != self.height - 1) col = self.emptySquareCol;
    }
    
    if ([self checkDirection:sender.direction forRow:row andCol:col]) {
        [self tapLocationAtRow:row andCol:col];
    }
}

#pragma mark - Block Movement

- (void)tapLocationAtRow:(int)row andCol:(int)col {
    NSMutableArray *blocksToMove = [NSMutableArray array];
    UISwipeGestureRecognizerDirection direction;
    
    if (row == self.emptySquareRow) {
        if (col < self.emptySquareCol) {
            direction = UISwipeGestureRecognizerDirectionRight;
            for (int c = col; c < self.emptySquareCol; c++) {
                [blocksToMove addObject:self.grid[row][c]];
            }
        }
        else if (col > self.emptySquareCol) {
            direction = UISwipeGestureRecognizerDirectionLeft;
            for (int c = self.emptySquareCol + 1; c <= col; c++) {
                [blocksToMove addObject:self.grid[row][c]];
            }
        }
    }
    else if (col == self.emptySquareCol) {
        if (row < self.emptySquareRow) {
            direction = UISwipeGestureRecognizerDirectionDown;
            for (int r = row; r < self.emptySquareRow; r++) {
                [blocksToMove addObject:self.grid[r][col]];
            }
        }
        else if (row > self.emptySquareRow) {
            direction = UISwipeGestureRecognizerDirectionUp;
            for (int r = row; r > self.emptySquareRow; r--) {
                [blocksToMove addObject:self.grid[r][col]];
            }
        }
    }
    
    if (direction) {
        [self moveBlocks:blocksToMove inDirection:direction];
        self.emptySquareRow = row;
        self.emptySquareCol = col;
        self.grid[row][col] = [NSNull null];
    }
}

- (void)moveBlocks:(NSArray *)blocks inDirection:(UISwipeGestureRecognizerDirection)direction {
    [UIView animateWithDuration:0.12 animations:^{
        for (BlockView *block in blocks) {
            if ([block isEqual:[NSNull null]]) continue;
            
            if (direction == UISwipeGestureRecognizerDirectionRight) {
                block.col += 1;
                CGRect blockFrame = block.frame;
                blockFrame.origin.x += self.blockSize + blockInset;
                block.frame = blockFrame;
            }
            else if (direction == UISwipeGestureRecognizerDirectionLeft) {
                block.col -= 1;
                CGRect blockFrame = block.frame;
                blockFrame.origin.x -= self.blockSize + blockInset;
                block.frame = blockFrame;
            }
            else if (direction == UISwipeGestureRecognizerDirectionDown) {
                block.row += 1;
                CGRect blockFrame = block.frame;
                blockFrame.origin.y += self.blockSize + blockInset;
                block.frame = blockFrame;
            }
            else if (direction == UISwipeGestureRecognizerDirectionUp) {
                block.row -= 1;
                CGRect blockFrame = block.frame;
                blockFrame.origin.y -= self.blockSize + blockInset;
                block.frame = blockFrame;
            }
            self.grid[block.row][block.col] = block;
        }
    } completion:^(BOOL finished) {
        if (self.isSolved) [self.delegate gridSolved];
    }];
    
    [self.delegate moveMade];
    if (self.isSolved) self.userInteractionEnabled = NO;
}

- (BOOL)checkDirection:(UISwipeGestureRecognizerDirection)direction forRow:(int)row andCol:(int)col {
    if (row == self.emptySquareRow) {
        if (col > self.emptySquareCol) {
            return direction == UISwipeGestureRecognizerDirectionLeft;
        }
        else if (col < self.emptySquareCol) {
            return direction == UISwipeGestureRecognizerDirectionRight;
        }
    }
    else if (col == self.emptySquareCol) {
        if (row > self.emptySquareRow) {
            return direction == UISwipeGestureRecognizerDirectionUp;
        }
        else if (row < self.emptySquareRow) {
            return direction == UISwipeGestureRecognizerDirectionDown;
        }
    }
        
    return NO;
}

#pragma mark - Grid Scrambling

- (void)scramble {
    [self resetGrid];
    self.grid = [self scrambledGrid];
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.6 animations:^{
        for (int r = 0; r < self.height; r++) {
            for (int c = 0; c < self.width; c++) {
                if ([self.grid[r][c] isKindOfClass:[BlockView class]]) {
                    BlockView *block = self.grid[r][c];
                    block.frame = [self blockFrameFromRow:block.row andCol:block.col];
                }
                else {
                    self.emptySquareRow = r;
                    self.emptySquareCol = c;
                }
            }
        }
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (NSMutableArray *)scrambledGrid {
    NSMutableArray *grid = [self.grid mutableCopy];
    NSUInteger directions[4] = {UISwipeGestureRecognizerDirectionLeft,
                               UISwipeGestureRecognizerDirectionRight,
                               UISwipeGestureRecognizerDirectionUp,
                               UISwipeGestureRecognizerDirectionDown};
    
    int emptySquareRow = self.height - 1;
    int emptySquareCol = self.width - 1;
    UISwipeGestureRecognizerDirection reversePreviousDirection = UISwipeGestureRecognizerDirectionUp;
    NSMutableArray *forbiddenDirections = [NSMutableArray array];
    
    for (int i = 0; i < 100 * self.height * self.width; i++) {
        // Update forbidden directions due to the empty square being at the edge of the board
        [forbiddenDirections removeAllObjects];
        if (emptySquareRow == 0) {
            [forbiddenDirections addObject:@(UISwipeGestureRecognizerDirectionDown)];
        }
        if (emptySquareRow == self.height - 1) {
            [forbiddenDirections addObject:@(UISwipeGestureRecognizerDirectionUp)];
        }
        if (emptySquareCol == 0) {
            [forbiddenDirections addObject:@(UISwipeGestureRecognizerDirectionRight)];
        }
        if (emptySquareCol == self.width - 1) {
            [forbiddenDirections addObject:@(UISwipeGestureRecognizerDirectionLeft)];
        }
        
        UISwipeGestureRecognizerDirection direction = reversePreviousDirection;
        
        // Choose random direction and simulate a swipe
        while (direction == reversePreviousDirection || [forbiddenDirections containsObject:@(direction)]) {
            direction = directions[(arc4random() % 4)];
        }
        
        if (direction == UISwipeGestureRecognizerDirectionLeft) {
            grid[emptySquareRow][emptySquareCol] = grid[emptySquareRow][emptySquareCol + 1];
            grid[emptySquareRow][emptySquareCol + 1] = [NSNull null];
            emptySquareCol += 1;
            reversePreviousDirection = UISwipeGestureRecognizerDirectionRight;
        }
        else if (direction == UISwipeGestureRecognizerDirectionRight) {
            grid[emptySquareRow][emptySquareCol] = grid[emptySquareRow][emptySquareCol - 1];
            grid[emptySquareRow][emptySquareCol - 1] = [NSNull null];
            emptySquareCol -= 1;
            reversePreviousDirection = UISwipeGestureRecognizerDirectionLeft;
        }
        if (direction == UISwipeGestureRecognizerDirectionUp) {
            grid[emptySquareRow][emptySquareCol] = grid[emptySquareRow + 1][emptySquareCol];
            grid[emptySquareRow + 1][emptySquareCol] = [NSNull null];
            emptySquareRow += 1;
            reversePreviousDirection = UISwipeGestureRecognizerDirectionDown;
        }
        else if (direction == UISwipeGestureRecognizerDirectionDown) {
            grid[emptySquareRow][emptySquareCol] = grid[emptySquareRow - 1][emptySquareCol];
            grid[emptySquareRow - 1][emptySquareCol] = [NSNull null];
            emptySquareRow -= 1;
            reversePreviousDirection = UISwipeGestureRecognizerDirectionUp;
        }
    }
    
    // Update block row and column information
    for (int r = 0; r < self.height; r++) {
        for (int c = 0; c < self.width; c++) {
            if ([grid[r][c] isKindOfClass:[BlockView class]]) {
                BlockView *block = grid[r][c];
                block.row = r;
                block.col = c;
            }
        }
    }
    
    return grid;
}

#pragma mark - Game Status

- (BOOL)isSolved {
    for (BlockView *block in self.blocks) {
        if (block.row != (block.blockNumber - 1) / self.width || block.col != (block.blockNumber - 1) % self.width) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Helper Methods

- (CGRect)blockFrameFromRow:(int)row andCol:(int)col {
    return CGRectMake(col * (self.blockSize + blockInset) + blockInset, row * (self.blockSize + blockInset) + blockInset, self.blockSize, self.blockSize);
}
             
@end
