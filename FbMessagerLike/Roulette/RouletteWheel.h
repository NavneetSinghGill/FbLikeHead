//
//  RouletteWheel.h
//  FbMessagerLike
//
//  Created by stplmacmini11 on 06/01/17.
//  Copyright © 2017 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RouletteWheelDelegate <NSObject, UIGestureRecognizerDelegate>



@end

@interface RouletteWheel : UIView

@property(assign, nonatomic) id<RouletteWheelDelegate> delegate;

@property(nonatomic) IBInspectable NSInteger radius;

@end
