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
        [self.collectionView registerClass:UICollectionViewCell.class
                forCellWithReuseIdentifier:@"modeCell"];
        [self.collectionView registerClass:UICollectionViewCell.class
                forCellWithReuseIdentifier:@"colorCell"];
        [self.view addSubview:self.collectionView];
        
        [self updateViewConstraints];
        [self.collectionView.collectionViewLayout collectionViewContentSize];
        [self.collectionView reloadData];
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(80.0);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)setGameColor:(UIColor *)color {
    [[NSUserDefaults standardUserDefaults] setColor:color forKey:@"mainColor"];
    [(SlideRootViewController *)self.navigationController
        updateNavigationControllerColorsWithColor:color];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colors.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
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
