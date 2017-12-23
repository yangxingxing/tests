//
//  HSUIImageButton.m
//  
//
//  Created by apple on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSUIImageButton.h"


@interface HSUIImageButton ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation HSUIImageButton


-(id)init
{
    self = [super init];
    if (self)
        [self selfInit];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
        [self selfInit];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self selfInit];
    return self;
}

-(id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self)
        [self selfInit];
    return self;
}

-(void)selfInit
{
    [self setUserInteractionEnabled:TRUE];
    self.exclusiveTouch  = YES;
    if (!_longPressGestureRecognizer)
    {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handleLongPressGestures:)];
        _longPressGestureRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_longPressGestureRecognizer];
    }
}

-(void)dealloc
{
    if (_longPressGestureRecognizer)
    {
        [self removeGestureRecognizer:_longPressGestureRecognizer];
    }
    self.longPressGestureRecognizer = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    if ([paramSender isEqual:_longPressGestureRecognizer])
    {
        if (paramSender.state == UIGestureRecognizerStateBegan){
            
            if (_delegate && [_delegate respondsToSelector:@selector(imageButtonLongClick:)])
                [_delegate imageButtonLongClick:self];
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(imageButton:LongPressGestures:)])
                [_delegate imageButton:self LongPressGestures:paramSender];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    if (touch.view == self && _delegate &&[_delegate respondsToSelector:@selector(imageButtonClick:)])
        [_delegate imageButtonClick:self];
}

@end
