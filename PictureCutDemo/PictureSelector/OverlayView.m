//
//  OverlayView.m
//  nvbs
//
//  Created by Cater on 17/2/9.
//  Copyright © 2017年 HeNanRunShengXXJS. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(contextRef, YES);
    
    // Fill black
    CGContextSetFillColorWithColor(contextRef, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGContextAddRect(contextRef, self.bounds);
    CGContextFillPath(contextRef);
    
    CGContextClearRect(contextRef, self.clearRect);
    CGContextFillPath(contextRef);
    
    CGContextStrokePath(contextRef);
    
}

@end
