//
//  RippleAnimation.m
//  RYHFG
//
//  Created by Yurii.B on 8/9/14.
//  Copyright (c) 2014 YuriiBogdan. All rights reserved.
//

#import "RippleAnimation.h"

@implementation RippleAnimation

/* Sample Use
 
 [RippleAnimation showRippleAnimationToImage:_cameraImageView completion:^(BOOL finished) {
 [self openPickerController];
 }];
 
 */

+ (void)showRippleAnimationToImage:(UIImageView *)imageView completion:(void (^)(BOOL finished))completion {
    // Make animation in Circle shape
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    UIColor *stroke = [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1] ? [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1] : [UIColor colorWithWhite:0.8 alpha:0.8];
    
    CGRect pathFrame = CGRectMake(-CGRectGetMidX(imageView.bounds), -CGRectGetMidY(imageView.bounds), imageView.bounds.size.width, imageView.bounds.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:imageView.layer.cornerRadius];
    
    // accounts for left/right offset and contentOffset of scroll view
    CGPoint shapePosition = [imageView convertPoint:imageView.center fromView:nil];
    
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = path.CGPath;
    circleShape.position = shapePosition;
    circleShape.fillColor = [UIColor clearColor].CGColor;
    circleShape.opacity = 0;
    circleShape.strokeColor = stroke.CGColor;
    circleShape.lineWidth = 3;
    
    [imageView.layer addSublayer:circleShape];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.duration = 0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [circleShape addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:0.1 animations:^{
        imageView.alpha = 0.4;
        imageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.9].CGColor;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            imageView.alpha = 1;
            imageView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.9].CGColor;
        } completion:^(BOOL finished) {
            if (finished) {
                completion(finished);
            }
        }];
    }];
}

@end
