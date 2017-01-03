//  Copyright © 2017 Insi. All rights reserved.

#import "ThemeViewController.h"


@interface ThemeFlowLayout : UICollectionViewFlowLayout

@end


@implementation ThemeFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat leftColumnXoffset =
            (self.collectionView.bounds.size.width - 2 * self.itemSize.width -
                self.minimumInteritemSpacing) / 2;
        CGFloat rightColumnXoffset = self.collectionView.bounds.size.width - leftColumnXoffset - self.itemSize.width;
        
        CGRect originalFrame = attribute.frame;
        attribute.frame =
            CGRectMake((attribute.indexPath.item % 2 == 0) ? leftColumnXoffset : rightColumnXoffset,
                       originalFrame.origin.y,
                       originalFrame.size.width,
                       originalFrame.size.height);
    }
    return attributes;
}

@end


@interface ThemeViewController ()

@property NSArray *colors;
@property NSArray *colorNames;

@property UIView *modeChooser;
@property UILabel *darkMenuLabel;
@property UISwitch *darkMenuSwitch;
@property UICollectionView *collectionView;

@end


@implementation ThemeViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"Theme";
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.colors = @[UIColor.slideBlue, UIColor.slideRed, UIColor.slideGreen, UIColor.slidePink, UIColor.blackColor];
        self.colorNames = @[@"Blue", @"Red", @"Green", @"Pink", @"Black"];

        self.darkMenuLabel = [UILabel new];
        self.darkMenuLabel.text = @"Dark Menu Bar";
        self.darkMenuLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.darkMenuLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
        [self.view addSubview:self.darkMenuLabel];
        
        self.darkMenuSwitch = [UISwitch new];
        self.darkMenuSwitch.onTintColor = UIColor.slideMainColor;
        [self.darkMenuSwitch addTarget:self
                                action:@selector(setDarkMenu:)
                      forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.darkMenuSwitch];
        
        UICollectionViewFlowLayout* flowLayout = [ThemeFlowLayout new];
        flowLayout.itemSize = CGSizeMake(150.0, 170.0);
        flowLayout.minimumInteritemSpacing = 10.0;
        flowLayout.headerReferenceSize = CGSizeZero;
        
        self.collectionView =
            [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = UIColor.whiteColor;
        self.collectionView.contentInset = UIEdgeInsetsZero;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsVerticalScrollIndicator = YES;
        [self.collectionView registerClass:UICollectionViewCell.class
                forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:self.collectionView];
        
        // Disable multiple touches
        [self.view.subviews makeObjectsPerformSelector:@selector(setExclusiveTouch:)
                                            withObject:[NSNumber numberWithBool:YES]];
        [self updateViewConstraints];
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    UICollectionViewFlowLayout *flowLayout =
        (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat centerOffset = (flowLayout.itemSize.width + 100.0 + flowLayout.minimumInteritemSpacing) / 2.0;
    
    [self.darkMenuLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.darkMenuSwitch);
        make.left.equalTo(self.view.mas_centerX).with.offset(-centerOffset);
        make.right.equalTo(self.darkMenuSwitch.mas_left);
        make.height.mas_equalTo(20.0);
    }];
    
    [self.darkMenuSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(85.0);
        make.right.equalTo(self.view.mas_centerX).with.offset(centerOffset);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(135.0);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"darkMenu"] != nil) {
        self.darkMenuSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"darkMenu"];
    }
    else {
        self.darkMenuSwitch.on = NO;
    }

    int selectedIndex = -1;
    for (int i = 0; i < self.colors.count; i++) {
        if ([self.colors[i] isEqualToColor:UIColor.slideMainColor]) selectedIndex = i;
    }
    
    if (selectedIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        [self.collectionView layoutIfNeeded];
        [self.collectionView selectItemAtIndexPath:indexPath
                                          animated:NO
                                    scrollPosition:UICollectionViewScrollPositionNone];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        UILabel *colorView = (UILabel *)[cell viewWithTag:1];
        colorView.text = @"✔︎";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView flashScrollIndicators];
}

- (void)setDarkMenu:(id)sender {
    ((SlideRootViewController *)self.navigationController).navigationBarTransparent = ![sender isOn];
    [(SlideRootViewController *)self.navigationController
        updateNavigationControllerColorsWithColor:UIColor.slideMainColor];
    [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:@"darkMenu"];
}

- (void)setGameColor:(UIColor *)color {
    [[NSUserDefaults standardUserDefaults] setColor:color forKey:@"mainColor"];
    [(SlideRootViewController *)self.navigationController
        updateNavigationControllerColorsWithColor:color];
    self.darkMenuSwitch.onTintColor = color;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) cell = [UICollectionViewCell new];
    
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *colorView = [UILabel new];
    colorView.tag = 1;
    colorView.backgroundColor = self.colors[indexPath.row];
    colorView.clipsToBounds = YES;
    colorView.layer.cornerRadius = 10.0;
    colorView.text = (cell.selected) ? @"✔︎" : @"";
    colorView.textAlignment = NSTextAlignmentCenter;
    colorView.textColor = UIColor.whiteColor;
    colorView.font = [UIFont systemFontOfSize:30.0];
    [cell addSubview:colorView];
    [colorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(cell);
        make.height.width.mas_equalTo(100.0);
    }];

    UILabel *colorLabel = [UILabel new];
    colorLabel.tag = 2;
    colorLabel.text = self.colorNames[indexPath.row];
    colorLabel.textColor = self.colors[indexPath.row];
    colorLabel.textAlignment = NSTextAlignmentCenter;
    colorLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    [cell addSubview:colorLabel];
    [colorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(colorView.mas_bottom);
        make.width.centerX.bottom.equalTo(cell);
    }];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView scrollToItemAtIndexPath:indexPath
                           atScrollPosition:UICollectionViewScrollPositionNone
                                   animated:YES];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *colorView = (UILabel *)[cell viewWithTag:1];
    colorView.text = @"✔︎";
    [self setGameColor:colorView.backgroundColor];
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    ((UILabel *)[cell viewWithTag:1]).text = @"";
}

@end
