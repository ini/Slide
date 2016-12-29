//  Copyright © 2016 Insi. All rights reserved.

#import "SlideButton.h"


@interface SlideButton ()

@property UIView *highlightMask;

@end


@implementation SlideButton

- (id)init {
    self = [super init];
    
    if (self) {
        self.clipsToBounds = YES;
        self.highlightMask = [UIView new];
        self.highlightMask.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        self.highlightMask.hidden = YES;
        [self addSubview:self.highlightMask];
    }
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.highlightMask mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.highlightMask.hidden = NO;
    }
    else {
        self.highlightMask.hidden = YES;
    }
}

@end
