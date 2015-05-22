//
//  GameViewController.m
//  Slide
//
//  Created by Ini on 8/25/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"

@interface GameViewController ()
{
    BOOL _bannerIsVisible;
    ADBannerView *_adBanner;
}
@end


@implementation GameViewController

int milSec;
int sec;
int min;
int hour;


#pragma mark Initialization


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.pauseButton.titleLabel.text isEqualToString:@"PAUSE"] && ![timerLabel.text isEqualToString:@"0.00"])
    {
        [self pause:nil];
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myGameViewController = self;
    self.sv.delegate = self;
    self.sv.contentSize = CGSizeMake(self.sv.frame.size.width, 176);
    self.bestTime = [NSString stringWithFormat:@"bestTime%i", self.gridSize];
    self.bestMoveCount = [NSString stringWithFormat:@"bestMoveCount%i", self.gridSize];
    self.bestyTime = [NSString stringWithFormat:@"Best_Time_%i", self.gridSize];
    self.bestyMoveCount = [NSString stringWithFormat:@"Best_Moves_%i", self.gridSize];
    [self updateHighScore];
    [self updateGameCenterAchievements];
    
    if ([timerLabel.text  isEqual: @"0.00"])
    {
        self.model = [[MoveController alloc] init];
        self.model.SIZE = self.gridSize;
        self.model.emptyLocation = [NSMutableArray arrayWithCapacity:(2)];
        self.model.blocksToMove = [NSMutableArray arrayWithCapacity:(self.gridSize)];
        [self.model.emptyLocation addObject:@(self.gridSize + 1)];
        [self.model.emptyLocation addObject:@(self.gridSize + 1)];
        [self.model.blocksToMove addObject:@"Q"];
        [self performSelector:@selector(scramble) withObject:nil afterDelay:1.5];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"paidFor"])
    {
        self.adBanner.frame = CGRectMake(0, self.view.frame.size.height - 50, self.adBanner.frame.size.width, self.adBanner.frame.size.height);
        self.adBanner.delegate = self;
        [self.view addSubview:self.adBanner];
        self.adBanner.hidden = NO;
        [self.view bringSubviewToFront:self.adBanner];
        NSLog([NSString stringWithFormat:@"%f, %f, %f", self.adBanner.frame.origin.x, self.adBanner.frame.origin.y, self.view.frame.size.height]);
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat aspectRatio = screenRect.size.height / screenRect.size.width;
    if (aspectRatio == 3.0/2.0 || aspectRatio == 2.0/3.0)
    {
        [self.sv setContentSize:CGSizeMake(320, 176)];
        CGPoint bottomOffset = CGPointMake(0, self.sv.contentSize.height - self.sv.bounds.size.height);
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.sv.contentOffset = bottomOffset;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark Game Setup


- (void)resetLocations
{
    for (BlockView *block in self.blocks)
    {
        block.location = [block getLocation];
    }
}

- (void)scramble
{
    NSArray *grid = [self.model getScrambledGrid];
    
    for (int i = 1; i < (self.gridSize * self.gridSize); i++)
    {
        [(BlockView *)(self.blocks[i-1]) setActualLocation:[[grid objectAtIndex:i] intValue]];
    }
    
    int emptyLoc = [[grid objectAtIndex:0] intValue];
    int emptyRow = (int)((emptyLoc - 1) / self.gridSize) + 1;
    int emptyCol = (emptyLoc - ((emptyRow - 1) * self.gridSize));
    
    [self.model.emptyLocation removeAllObjects];
    [self.model.emptyLocation addObject:@(emptyRow)];
    [self.model.emptyLocation addObject:@(emptyCol)];
    [self resetLocations];
    [self stopTimer];
    [self resetTimer];
    self.model.moveCount = 0;
    moveLabel.text = @"No Moves";
    timerLabel.text = @"0.00";
}


#pragma mark User Interaction


- (IBAction)rightSwipe:(id)sender {
    int x = [self.rightSwiper locationOfTouch:0 inView:self.backGround].x;
    int col = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (x > start && x < end)
        {
            col = i + 1;
        }
    }
    if (col == [[self.model.emptyLocation objectAtIndex:1] intValue])
    {
        col--;
    }

    int row = [[self.model.emptyLocation objectAtIndex:0] intValue];
    int loc = [self getLocationFromPoint:(int)row and:col];
    [self tapLocation:loc and:UISwipeGestureRecognizerDirectionRight];
}

- (IBAction)leftSwipe:(id)sender {
    int x = [self.leftSwiper locationOfTouch:0 inView:self.backGround].x;
    int col = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (x > start && x < end)
        {
            col = i + 1;
        }
    }
    if (col == [[self.model.emptyLocation objectAtIndex:1] intValue])
    {
        col++;
    }
    
    int row = [[self.model.emptyLocation objectAtIndex:0] intValue];
    int loc = [self getLocationFromPoint:(int)row and:col];
    [self tapLocation:loc and:UISwipeGestureRecognizerDirectionLeft];
}

- (IBAction)downSwipe:(id)sender {
    int y = [self.downSwiper locationOfTouch:0 inView:self.backGround].y;
    int row = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (y > start && y < end)
        {
            row = i + 1;
        }
    }
    if (row == [[self.model.emptyLocation objectAtIndex:0] intValue])
    {
        row--;
    }
    
    int col = [[self.model.emptyLocation objectAtIndex:1] intValue];
    int loc = [self getLocationFromPoint:(int)row and:col];
    [self tapLocation:loc and:UISwipeGestureRecognizerDirectionDown];
}

- (IBAction)upSwipe:(id)sender {
    int y = [self.upSwiper locationOfTouch:0 inView:self.backGround].y;
    int row = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (y > start && y < end)
        {
            row = i + 1;
        }
    }
    if (row == [[self.model.emptyLocation objectAtIndex:0] intValue])
    {
        row++;
    }

    int col = [[self.model.emptyLocation objectAtIndex:1] intValue];
    int loc = [self getLocationFromPoint:(int)row and:col];
    [self tapLocation:loc and:UISwipeGestureRecognizerDirectionUp];
}

- (IBAction)tap:(id)sender {
    int x = [self.tappy locationOfTouch:0 inView:self.backGround].x;
    int col = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (x > start && x < end)
        {
            col = i + 1;
        }
    }
    
    int y = [self.tappy locationOfTouch:0 inView:self.backGround].y;
    int row = 0;
    for (int i = 0; i < self.gridSize; i++)
    {
        int start = 11 + i * (self.blockSize + self.spacing);
        int end = start + self.blockSize;
        if (y > start && y < end)
        {
            row = i + 1;
        }
    }

    int loc = [self getLocationFromPoint:(int)row and:col];
    
    if ((row == [self.model.emptyLocation[0] intValue] || col == [self.model.emptyLocation[1] intValue]) && loc > 0 && row > 0 && col > 0 && !(row == [self.model.emptyLocation[0] intValue] && col == [self.model.emptyLocation[1] intValue]))
    {
        [self.model getMove:(loc)];
        [self startMoves];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat aspectRatio = screenRect.size.height / screenRect.size.width;
    if (aspectRatio == 3.0/2.0 || aspectRatio == 2.0/3.0)
    {
        if (([self.pauseButton.titleLabel.text  isEqual: @"PAUSE"]))
        {
            [self pause:nil];
        }
    }
}


#pragma mark Moving Blocks


- (void)startMoves
{
    if (!timerOn)
    {
        [self pause:nil];
    }

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat aspectRatio = screenRect.size.height / screenRect.size.width;
    if (aspectRatio == 3.0/2.0 || aspectRatio == 2.0/3.0)
    {
        CGPoint bottomOffset = CGPointMake(0, self.sv.contentSize.height - self.sv.bounds.size.height);
        [self.sv setContentOffset:bottomOffset animated:YES];
    }

    
    if (self.model.moveCount == 1)
    {
        moveLabel.text = @"1 Move";
    }
    else
    {
        moveLabel.text = [NSString stringWithFormat:@"%i Moves", self.model.moveCount];
    }

    if (!timerOn)
    {
        [self startTimer];
    }
    
    NSString *dir = [self.model.blocksToMove lastObject];
    for (int i = 1; i <= (self.gridSize * self.gridSize); i++)
    {
        if ([self.model.blocksToMove containsObject:@(i)])
        {
            [self startMovesHelper:i andDirection:dir];
        }
    }
    [self resetLocations];
    if ([self checkForWin])
    {
        [self iWonYay];
    }
}


#pragma mark Timer


- (void)startTimer
{
    Timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
    timerOn = YES;
}

- (void)stopTimer
{
    [Timer invalidate];
    timerOn = NO;
}

- (void)timerCount
{
    milSec++;
    if (milSec == 100)
    {
        sec++;
        milSec = 0;
    }
    if (sec == 60)
    {
        min++;
        sec = 0;
    }
    if (min == 60)
    {
        hour++;
        min = 0;
    }
    
    timerLabel.text = [self getTimerLabelText:milSec and:sec and:min and:hour];
}

- (void)resetTimer
{
    milSec = 0;
    sec = 0;
    min = 0;
    hour = 0;
}


#pragma mark End of Game


- (BOOL)checkForWin
{
    [self resetLocations];
    for (int i = 1; i < (self.gridSize * self.gridSize); i++)
    {
        if ( ((BlockView *) self.blocks[i - 1]).location != i )
        {
            return NO;
        }
    }
    return YES;
}

- (void)iWonYay
{
    self.rightSwiper.enabled = NO;
    self.leftSwiper.enabled = NO;
    self.upSwiper.enabled = NO;
    self.downSwiper.enabled = NO;
    self.tappy.enabled = NO;
    [self stopTimer];
    milSec = [[timerLabel.text substringFromIndex:(timerLabel.text.length - 2)] intValue];
    double time = 3600 * hour + 60 * min + sec + 0.01 * milSec;
    [self resetTimer];
    
    self.alertLabel.text = [NSString stringWithFormat:@"%@ in %@",moveLabel.text, timerLabel.text];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (time < [defaults doubleForKey:self.bestTime] || [defaults doubleForKey:self.bestTime] == 0)
    {
        if ([defaults doubleForKey:self.bestTime] != 0)
        {
            self.record.hidden = NO;
        }
        [defaults setObject:@(time) forKey:self.bestTime];
        [[GCHelper defaultHelper] reportScore:(time*100) forLeaderboardID:self.bestyTime];
    }
    if (self.model.moveCount < [defaults integerForKey:self.bestMoveCount] || [defaults integerForKey:self.bestMoveCount] == 0)
    {
        [defaults setObject:@(self.model.moveCount) forKey:self.bestMoveCount];
        [[GCHelper defaultHelper] reportScore:(self.model.moveCount) forLeaderboardID:self.bestyMoveCount];
    }
    
    self.model.moveCount = 0;
    
    [self updateHighScore];
    [self updateGameCenterAchievements];
    
    [self.view bringSubviewToFront:self.alert];
    [UIView transitionWithView:self.alert
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [self.alert setHidden:NO];
}

- (void)updateHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    double time = [defaults doubleForKey:self.bestTime];
    int move = (int)[defaults integerForKey:self.bestMoveCount];
    int myHour = (int) (time / 3600);
    int myMin = (int) ((time - (myHour * 3600)) / 60);
    int mySec = (int) (time - (myHour * 3600) - (myMin * 60));
    int myMilSec = (int)((double)(100.0 * (time - ((int)time))));
    
    NSString *timeString = [self getTimerLabelText:myMilSec and:mySec and:myMin and:myHour];
    NSString *moveString;
    if (move == 1)
    {
        moveString = @"1 move";
    }
    else
    {
        moveString = [NSString stringWithFormat:@"%i moves", move];
    }
    
    bestLabel.text = [NSString stringWithFormat:@"%@ in %@", moveString, timeString];
}


#pragma mark Buttons


- (IBAction)startOver:(id)sender {
    [self stopTimer];
    [self resetTimer];
    self.model.moveCount = 0;
    moveLabel.text = @"No Moves";
    timerLabel.text = @"0.00";
    [self scramble];
    if ([self.pauseButton.titleLabel.text isEqualToString:@"PAUSED"])
    {
        [self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
            [self.pauseButton setBackgroundColor:[UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1]];
        self.backGround.userInteractionEnabled = YES;
    }
}

- (IBAction)pause:(id)sender {
    if ([self.pauseButton.titleLabel.text isEqualToString:@"PAUSE"] && ![timerLabel.text isEqualToString:@"0.00"] && Timer.isValid && timerOn)
    {
        [self.pauseButton setTitle:@"PAUSED" forState:UIControlStateNormal];
        [self.pauseButton setBackgroundColor:[UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1]];
        [self stopTimer];
    }
    else if ([self.pauseButton.titleLabel.text isEqualToString:@"PAUSED"] && ![timerLabel.text isEqualToString:@"0.00"] && !Timer.isValid && !timerOn)
    {
        [self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        [self.pauseButton setBackgroundColor:[UIColor colorWithRed:(238/255.0) green:(238/255.0) blue:(238/255.0) alpha:1]];
        self.backGround.userInteractionEnabled = YES;
        [self startTimer];
    }
}

- (IBAction)playAgain:(id)sender {
    self.rightSwiper.enabled = YES;
    self.leftSwiper.enabled = YES;
    self.upSwiper.enabled = YES;
    self.downSwiper.enabled = YES;
    self.tappy.enabled = YES;
    self.record.hidden = YES;
    [UIView transitionWithView:self.alert
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [self.alert setHidden:YES];
    [self performSelector:@selector(startOver:) withObject:nil afterDelay:.7];
}
- (IBAction)opt:(id)sender {
    CGRect here = self.optionView.frame;
    here.origin.x = 0;
    [UIView animateWithDuration:0.75 animations:^{self.optionView.frame = here;}];
    
    if ([self.pauseButton.titleLabel.text isEqualToString:@"PAUSE"] && ![timerLabel.text isEqualToString:@"0.00"])
    {
        [self.pauseButton setTitle:@"PAUSED" forState:UIControlStateNormal];
        [self.pauseButton setBackgroundColor:[UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1]];
        [self stopTimer];
    }
}

- (IBAction)backOpt:(id)sender {
    CGRect there = self.optionView.frame;
    there.origin.x = -325;
    [UIView animateWithDuration:.75 animations:^{self.optionView.frame = there;}];
}


#pragma mark Helper Methods


- (void)startMovesHelper:(int)loc andDirection:(NSString *)dir
{
    for (BlockView *block in self.blocks)
    {
        if (block.location == loc) {
            [block moveBlock:dir];
        }
    }
}

- (void)tapLocation:(int)locNum and:(UISwipeGestureRecognizerDirection)direction
{
    if ([self.model checkDirection:direction andInt:locNum] && locNum > 0 && locNum <= (self.gridSize  * self.gridSize))
    {
        [self resetLocations];
        [self.model getMove:(locNum)];
        [self startMoves];
    }
}

- (void)updateGameCenterAchievements
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults doubleForKey:@"bestTime3"] > 0)
    {
        [[GCHelper defaultHelper] reportAchievementIdentifier:@"beatEasy" percentComplete:100.0f];
        
        if ([defaults doubleForKey:@"bestTime3"] < 30)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"easy30" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime3"] < 15)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"easy15" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime3"] < 5)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"easy5" percentComplete:100.0f];
        }
    }
    
    if ([defaults doubleForKey:@"bestTime4"] > 0)
    {
        [[GCHelper defaultHelper] reportAchievementIdentifier:@"beatMedium" percentComplete:100.0f];

        if ([defaults doubleForKey:@"bestTime4"] < 60)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"medium1" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime4"] < 30)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"medium30" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime4"] < 15)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"medium15" percentComplete:100.0f];
        }
    }
    
    if ([defaults doubleForKey:@"bestTime5"] > 0)
    {
        [[GCHelper defaultHelper] reportAchievementIdentifier:@"beatHard" percentComplete:100.0f];
        
        if ([defaults doubleForKey:@"bestTime5"] < 120)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"hard2" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime5"] < 60)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"hard1" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestTime5"] < 30)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"hard30" percentComplete:100.0f];
        }
    }
    
    if ([defaults doubleForKey:@"bestMoveCount3"] > 0)
    {
        if ([defaults doubleForKey:@"bestMoveCount3"] < 100)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"100easy" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount3"] < 50)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"50easy" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount3"] < 15)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"15easy" percentComplete:100.0f];
        }
    }
    
    if ([defaults doubleForKey:@"bestMoveCount4"] > 0)
    {
        if ([defaults doubleForKey:@"bestMoveCount4"] < 200)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"200medium" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount4"] < 100)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"100medium30" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount4"] < 50)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"50medium15" percentComplete:100.0f];
        }
    }
    
    if ([defaults doubleForKey:@"bestMoveCount3"] > 0)
        {
        if ([defaults doubleForKey:@"bestMoveCount5"] < 300)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"300hard" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount5"] < 150)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"150hard" percentComplete:100.0f];
        }
        if ([defaults doubleForKey:@"bestMoveCount5"] < 75)
        {
            [[GCHelper defaultHelper] reportAchievementIdentifier:@"75hard" percentComplete:100.0f];
        }
    }
}

- (NSString *)getTimerLabelText:(int)milSec and:(int)sec and:(int)min and:(int)hour
{
    if (hour == 0)
    {
        if (min == 0)
        {
            if (milSec < 10)
            {
                return [NSString stringWithFormat:@"%i.0%i", sec, milSec];
            }
            else
            {
                return [NSString stringWithFormat:@"%i.%i", sec, milSec];
            }
        }
        else
        {
            if (milSec < 10 && sec < 10)
            {
                return [NSString stringWithFormat:@"%i:0%i.0%i", min, sec, milSec];
            }
            else if (milSec < 10)
            {
                return [NSString stringWithFormat:@"%i:%i.0%i", min, sec, milSec];
            }
            else if (sec < 10)
            {
                return [NSString stringWithFormat:@"%i:0%i.%i", min, sec, milSec];
            }
            else
            {
                return [NSString stringWithFormat:@"%i:%i.%i", min, sec, milSec];
            }
        }
    }
    else
    {
        if (milSec < 10 && sec < 10 && min < 10)
        {
            return [NSString stringWithFormat:@"%i:0%i:0%i.0%i", hour, min, sec, milSec];
        }
        else if (milSec < 10 && sec < 10)
        {
            return [NSString stringWithFormat:@"%i:%i:0%i.0%i", hour, min, sec, milSec];
        }
        else if (milSec < 10 && min < 10)
        {
            return [NSString stringWithFormat:@"%i:0%i:%i.0%i", hour, min, sec, milSec];
        }
        else if (sec < 10 && min < 10)
        {
            return [NSString stringWithFormat:@"%i:0%i:0%i.%i", hour, min, sec, milSec];
        }
        else if (milSec < 10)
        {
            return [NSString stringWithFormat:@"%i:%i:%i.0%i", hour, min, sec, milSec];
        }
        else if (sec < 10)
        {
            return [NSString stringWithFormat:@"%i:%i:0%i.%i", hour, min, sec, milSec];
        }
        else if (min < 10)
        {
            return [NSString stringWithFormat:@"%i:0%i:%i.%i", hour, min, sec, milSec];
        }
        else
        {
            return [NSString stringWithFormat:@"%i:%i:%i.%i", hour, min, sec, milSec];
        }
    }
    
    return @"0.00";
}

- (NSArray *)getPointFromLocation:(int)loc
{
    int col = loc % self.gridSize;
    if (col == 0)
    {
        col = self.gridSize;
    }
    int row = (int) (((loc - 1) / self.gridSize) + 1);
    return [[NSArray alloc] initWithObjects:@(row), @(col), nil];
}

- (int)getLocationFromPoint:(int)row and:(int)col
{
    return (row - 1) * self.gridSize + col;
}



@end
