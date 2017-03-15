//
//  RouletteWheel.m
//  FbMessagerLike
//
//  Created by stplmacmini11 on 06/01/17.
//  Copyright © 2017 asdasd. All rights reserved.
//

#import "RouletteWheel.h"

#define radian(x) (x*M_PI)/180

typedef enum {
    ClockWise = 0,
    AntiClockWise
} RotationDirection;

@implementation RouletteWheel {
    NSTimer *timer;
    CGFloat degreesToRotateAtOnce;
    CGFloat currentDegreesToRotate;
    NSTimeInterval timerDuration;
    
    CGPoint secondLastPoint;
    CGPoint lastPoint;
    CGPoint touchUpPoint;
    RotationDirection rotationDirection;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self=[super initWithCoder:aDecoder])){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initialSetup];
        });
    }
    return self;
}

- (void)setRadius:(NSInteger)radius {
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

- (void)initialSetup {
    degreesToRotateAtOnce = currentDegreesToRotate = -10;
    timerDuration = 0.01;
    
    CGFloat diameter = (self.frame.size.height > self.frame.size.width ? self.frame.size.width: self.frame.size.height);
//    self.layer.cornerRadius = diameter / 2;
    
    UIBezierPath *bzPath = [[UIBezierPath alloc]init];
    [bzPath moveToPoint:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)];
    [bzPath addLineToPoint:CGPointMake(self.center.x - self.frame.origin.x + 5, self.center.y - self.frame.origin.y)];
    [bzPath addLineToPoint:CGPointMake(self.center.x - self.frame.origin.x+5, self.center.y - self.frame.origin.y + 5)];
    [bzPath addLineToPoint:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y + 5)];
    [bzPath addLineToPoint:CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y)];
    
    [[UIColor orangeColor] setStroke];
    
    [bzPath stroke];
    
//    [self];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didMove:)];
    panGesture.delegate = self.delegate;
    [self addGestureRecognizer:panGesture];
}

#pragma mark - Touch methods

- (void)didMove:(UIPanGestureRecognizer *)panGesture {
    NSLog(@"VELOCITY: %f %f", [panGesture velocityInView:self].x, [panGesture velocityInView:self].y);
    
    if ([self mod:[panGesture velocityInView:self].x] <= 200 && [self mod:[panGesture velocityInView:self].y] <= 200) {
        NSLog(@"VELOCITY IS LESS");
        return;
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"VELOCITY END: %f %f", [panGesture velocityInView:self].x, [panGesture velocityInView:self].y);
        
        degreesToRotateAtOnce = currentDegreesToRotate = [self getScalarVelocity:[panGesture velocityInView:self]] * timerDuration;
        
        touchUpPoint = [panGesture locationInView:self];
        NSLog(@"TouchUpPoint: %f %f", touchUpPoint.x, touchUpPoint.y);
        
        [self resetTimer];
        [self setDirection];
        
//        currentDegreesToRotate = rotationDirection == ClockWise ? -degreesToRotateAtOnce : degreesToRotateAtOnce;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:timerDuration target:self selector:@selector(rotationTimer:) userInfo:nil repeats:YES];
    } else {
        secondLastPoint = lastPoint;
        lastPoint = [panGesture locationInView:self];
        NSLog(@"LastPoint: %f %f", lastPoint.x, lastPoint.y);
        NSLog(@"SecondLastPoint: %f %f", secondLastPoint.x, secondLastPoint.y);
    }
}

- (void)rotateWithVelocity:(CGFloat)velocity andStopInSeconds:(CGFloat)seconds {
    
}

- (void)rotationTimer:(NSTimeInterval)time {
    if (rotationDirection == ClockWise) {
        currentDegreesToRotate-=0.5;
        if (currentDegreesToRotate <= 0) {
            [self resetTimer];
        }
    } else {
        currentDegreesToRotate+=0.5;
        if (currentDegreesToRotate >= 0) {
            [self resetTimer];
        }
    }
    self.transform = CGAffineTransformRotate(self.transform, radian(currentDegreesToRotate));
}

- (void)setDirection {
    CGFloat xDifference = lastPoint.x - secondLastPoint.x;
    CGFloat yDifference = lastPoint.y - secondLastPoint.y;
    
    if ([self mod:xDifference] >= [self mod:yDifference]) {
        if (lastPoint.y <= self.frame.size.height / 2) {
            rotationDirection = secondLastPoint.x > lastPoint.x ? AntiClockWise: ClockWise;
        } else {
            rotationDirection = secondLastPoint.x > lastPoint.x ? ClockWise : AntiClockWise;
        }
    } else {
        if (lastPoint.x <= self.frame.size.width / 2) {
            rotationDirection = secondLastPoint.y > lastPoint.y ? ClockWise: AntiClockWise;
        } else {
            rotationDirection = secondLastPoint.y > lastPoint.y ? AntiClockWise : ClockWise;
        }
    }
    if (rotationDirection == ClockWise) {
        currentDegreesToRotate = degreesToRotateAtOnce;
    } else {
        currentDegreesToRotate = -degreesToRotateAtOnce;
    }
    NSLog(@"%@", [NSString stringWithFormat:@"ROTATION: %@",rotationDirection == ClockWise? @"CW": @"ACW"]);
}

- (void)continueSpinning {
    
}

- (CGFloat)mod:(CGFloat)value {
    return value > 0 ? value: -value;
}

- (void)resetTimer {
    [timer invalidate];
    timer = nil;
}

- (NSInteger)getScalarVelocity:(CGPoint)velocity {
    return sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
}

@end
