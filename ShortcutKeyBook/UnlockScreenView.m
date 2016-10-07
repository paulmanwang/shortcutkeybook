//
//  UnlockScreenView.m
//  ShortcutKeyBook
//
//  Created by lichunwang on 16/9/30.
//  Copyright © 2016年 springcome. All rights reserved.
//

#import "UnlockScreenView.h"

@interface UnlockScreenView ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation UnlockScreenView

- (IBAction)onNumberButtonClicked:(id)sender
{
    UIButton *numberButton = (UIButton *)sender;
    NSString *strNumber = numberButton.title;
    
    NSString *currentPassword = self.passwordTextField.text;
    if (currentPassword.length == 0) {
        self.passwordTextField.text = strNumber;
    }
    else {
        self.passwordTextField.text = [currentPassword stringByAppendingString:strNumber];
    }
    
    if (self.passwordTextField.text.length == 6) {
        if (![self.passwordTextField.text isEqualToString:@"123456"]) {
            [self performShakeAnimation];
        }
        else {
            [self performFadeAnimation];
        }
    }
}

- (void)performShakeAnimation
{
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrameAnimation.values = @[@0, @10, @-10, @10, @0];
    keyFrameAnimation.keyTimes = @[@0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    keyFrameAnimation.duration = 0.4f;
    keyFrameAnimation.additive = YES; // 这个啥意思
    
    [self.passwordTextField.layer addAnimation:keyFrameAnimation forKey:@"kLabelShakeAnimation"];
}

- (void)performFadeAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.2;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
