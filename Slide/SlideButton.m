//  Copyright © 2016 Insi. All rights reserved.

#import "SlideButton.h"


@interface SlideButton ()

@end


@implementation SlideButton

- (id)init {
    self = [super init];
    
    if (self) {
        self.clipsToBounds = YES;
        self.highlightStyle = SlideButtonHighlightStyleBackground;
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

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlightStyle == SlideButtonHighlightStyleBackground) {
        self.highlightMask.hidden = !highlighted;
    }
    else if (self.highlightStyle == SlideButtonHighlightStyleText && highlighted) {
        if ([self.titleLabel.font.fontName isEqualToString:@"HelveticaNeue-Light"]) {
            self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                   size:self.titleLabel.font.pointSize];
        }
    }
    else if (self.highlightStyle == SlideButtonHighlightStyleText && !highlighted) {
        if ([self.titleLabel.font.fontName isEqualToString:@"HelveticaNeue"]) {
            self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light"
                                                   size:self.titleLabel.font.pointSize];
        }
    }
}

@end
