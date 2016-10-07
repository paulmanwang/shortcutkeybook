//
//  WLCSwipeView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/9/27.
//  Copyright © 2016年 springcome. All rights reserved.
//  手势与touch事件不冲突

#import "WLCSwipeView.h"

@interface WLCSwipeView ()

@property (assign, nonatomic) CGPoint beginPoint;

@end

@implementation WLCSwipeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
        redView.backgroundColor = [UIColor blackColor];
        [self addSubview:redView];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeGesture];
    }
    
    return self;
}

- (void)onSwipe:(UIGestureRecognizer *)gesture
{
    NSLog(@"WLCSWipeView onSwipe");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"WLCSWipeView touchesBegan");
    UITouch *touch = [touches anyObject];
    self.beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"WLCSWipeView touchesMoved");
    
    // 判断方向
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    
//    CGFloat xdiff = location.x - self.beginPoint.x;
//    CGFloat ydiff = location.y - self.beginPoint.y;
//    if (fabs(xdiff) > fabs(ydiff)) {
//        if (xdiff > 0) {
//            NSLog(@"向右");
//        }
//        else {
//            NSLog(@"向左");
//        }
//    }
//    else {
//        if (ydiff > 0) {
//            NSLog(@"向下");
//        } else {
//            NSLog(@"向上");
//        }
//    }
    
    // 判断移动区域
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (![self pointInside:location withEvent:nil]) {
        NSLog(@"不在WLCSwipeView内");
    }
    else {
        UIView *view = [self hitTest:location withEvent:nil];
        if (view == self) {
            NSLog(@"在WLCSwipeView内");
        }
        else {
            NSLog(@"在红色view内");
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"WLCSWipeView touchesCancelled");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"WLCSWipeView touchesEnded");
}

// 自己写的原始方法
//- (UIView *)hitTest:(CGPoint)point inView:(UIView *)view
//{
//    BOOL inside = [view pointInside:point withEvent:nil];
//    if (inside) {
//        if (view.subviews.count == 0) { // 这里是结束条件
//            return view;
//        }
//        else {
//            UIView *insideSubView = nil;
//            for (UIView *subView in view.subviews) { // 这里应该倒序，多个view同时pointInside都返回yes时，离屏幕更前的view优先成为hitTest视图
//                if ([subView pointInside:point withEvent:nil]) { // 肯定有满足条件的subView
//                    insideSubView = subView;
//                    break;
//                }
//            }
//            
//            return [insideSubView hitTest:point withEvent:nil];
//        }
//    }
//    else {
//        return nil;
//    }
//}

- (BOOL)pointInside:(CGPoint)point inView:(UIView *)view
{
    if (point.x >= 0 && point.x <= view.width && point.y >=0 && point.y <= view.height) {
        return YES;
    }
    
    return NO;
}

// 改造之后的方法
- (UIView *)hitTest:(CGPoint)point inView:(UIView *)view
{
    if (view.userInteractionEnabled == NO || view.hidden || view.alpha <= 0.01) {
        return nil;
    }
    
    if ([view pointInside:point withEvent:nil]) {
        return nil;
    }
    
    for (UIView *subView in [view.subviews reverseObjectEnumerator]) { // 这里要倒序遍历
        if ([subView pointInside:point withEvent:nil]) {
            CGPoint convertedPoint = [subView convertPoint:point fromView:view]; // 转换为subView内的坐标点
            return [self hitTest:convertedPoint inView:subView]; // 循环调用
        }
    }
    
    return self; // 返回条件为view.subviews.count == 0
}



@end
