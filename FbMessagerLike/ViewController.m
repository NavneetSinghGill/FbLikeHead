//
//  ViewController.m
//  FbMessagerLike
//
//  Created by stplmacmini11 on 04/01/17.
//  Copyright © 2017 asdasd. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    InArea = 0,
    OutOfArea,
    Dead
} ChatCicleState;

#define AreaRadius 150
#define BounceBackWidth 10
#define HiddenWidth 5
#define CancelCircleRadiusInArea 90
#define CancelCircleRadiusOutOfArea 60

@interface ViewController () <UIGestureRecognizerDelegate> {
    CGPoint hidingPoint;
    CGPoint holdingPoint;
    
    ChatCicleState chatCicleState;
}

@property(weak, nonatomic) IBOutlet UIView *chatButton;
@property(strong, nonatomic) IBOutlet UIImageView *crossImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hidingPoint.x = self.view.frame.size.width/2;
        hidingPoint.y = self.view.frame.size.height + _crossImageView.frame.size.height/2;
        
        holdingPoint.x = hidingPoint.x;
        holdingPoint.y = self.view.frame.size.height - _crossImageView.frame.size.height/2 - 30;
        
        _crossImageView.frame = CGRectMake(_crossImageView.frame.origin.x, _crossImageView.frame.origin.y, CancelCircleRadiusOutOfArea, CancelCircleRadiusOutOfArea);
        _chatButton.layer.cornerRadius = _chatButton.frame.size.height / 2;
        _chatButton.layer.masksToBounds = YES;
        _chatButton.clipsToBounds = YES;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didMove:)];
        panGesture.delegate = self;
        [_chatButton addGestureRecognizer:panGesture];
    });
}

- (void)didMove:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint pointInView = [gestureRecognizer locationInView:self.view];
    if ([self isFocusOfPoint:pointInView isInView:_chatButton] || ((_chatButton.center.x == _crossImageView.center.x) && (_chatButton.center.y == _crossImageView.center.y)) || chatCicleState == InArea) {
        
        CGFloat distance = [self distanceBetweenPointA:pointInView andPointB:holdingPoint];
        NSLog(@"ChatCenter: %f %f , pointInView: %f %f , Distance: %f", _chatButton.center.x, _chatButton.center.y, pointInView.x, pointInView.y, distance);
        
        CGFloat xDistance = holdingPoint.x - pointInView.x;
        xDistance = xDistance > 0? xDistance: - xDistance;
        
        CGFloat yDistance = holdingPoint.y - pointInView.y;
        yDistance = yDistance > 0? yDistance: - yDistance;
        
        CGPoint newCenter;
        newCenter.x = holdingPoint.x - pointInView.x < 0? holdingPoint.x + xDistance *.1 : holdingPoint.x -  xDistance*.1;
        newCenter.y = holdingPoint.y - pointInView.y < 0? holdingPoint.y + yDistance *.1 : holdingPoint.y -  yDistance*.1;
        
        if (distance > AreaRadius) {
            
            NSLog(@"Out of area");
            
            [UIView animateWithDuration:0.2f animations:^{
                _chatButton.center = pointInView;
                _crossImageView.center = newCenter;
                _crossImageView.frame = CGRectMake(_crossImageView.frame.origin.x, _crossImageView.frame.origin.y, CancelCircleRadiusOutOfArea, CancelCircleRadiusOutOfArea);
            }];
            
            chatCicleState = OutOfArea;
        } else {
            NSLog(@"In area");
            
            [UIView animateWithDuration:0.2f animations:^{
                _chatButton.center = _crossImageView.center;
                _crossImageView.center = newCenter;
                _crossImageView.frame = CGRectMake(_crossImageView.frame.origin.x, _crossImageView.frame.origin.y, CancelCircleRadiusInArea, CancelCircleRadiusInArea);
            }];
            
            chatCicleState = InArea;
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            //Closing state
            if (chatCicleState == OutOfArea) {
                CGFloat newX;
                newX = pointInView.x > self.view.frame.size.width/2 ? self.view.frame.size.width - _chatButton.frame.size.width/2 : _chatButton.frame.size.width/2;
                
                CGFloat bounceBackWidth = newX > self.view.frame.size.width/2? BounceBackWidth : -BounceBackWidth;
                CGFloat hiddenWidth = newX > self.view.frame.size.width/2? HiddenWidth : -HiddenWidth;
                
                [UIView animateWithDuration:0.3f animations:^{
                    _crossImageView.center = CGPointMake(hidingPoint.x, hidingPoint.y);
                    _chatButton.center = CGPointMake(newX + bounceBackWidth, _chatButton.center.y);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.15f animations:^{
                        _chatButton.center = CGPointMake(newX + hiddenWidth, _chatButton.center.y);
                    }];
                }];
            } else if (chatCicleState == InArea) {
                [UIView animateWithDuration:0.3f animations:^{
                    _crossImageView.center = CGPointMake(hidingPoint.x, hidingPoint.y);
                    _chatButton.center = CGPointMake(hidingPoint.x, hidingPoint.y);
                }];
            }
            chatCicleState = Dead;
            NSLog(@"ENDED in circle");
        }
    }
    
//    NSLog(@"DID MOVE: %f %f", pointInView.x, pointInView.y);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pointInMainView = [touch locationInView:self.view];
    if (chatCicleState == Dead) {
        _chatButton.center = pointInMainView;
    }
    
    CGPoint pointInView = [touch locationInView:_chatButton];
    NSLog(@"TOUCH BEGAN: %f %f", pointInView.x, pointInView.y);
    
    if ([touch.view isDescendantOfView:_chatButton]) {
        [UIView animateWithDuration:0.3f animations:^{
            _crossImageView.center = CGPointMake(holdingPoint.x, holdingPoint.y);
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject].view isDescendantOfView:_chatButton]) {
        
    } else {
        NSLog(@"END");
    }
}

- (BOOL)isFocusOfPoint:(CGPoint)point isInView:(UIView *)view {
    CGFloat x;
    x = point.x>0?point.x:-point.x;
    CGFloat y;
    y = point.y>0?point.y:-point.y;
    if ([self distanceBetweenPointA:point andPointB:view.center] > view.frame.size.width) {
        return NO;
    }
    return YES;
}

- (CGFloat)distanceBetweenPointA:(CGPoint)pointA andPointB:(CGPoint)pointB {
    return sqrtf(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2));
}

- (CGFloat)mod:(CGFloat)value {
    return value > 0 ? value: -value;
}

@end
