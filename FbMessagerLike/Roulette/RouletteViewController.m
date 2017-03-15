//
//  RouletteViewController.m
//  FbMessagerLike
//
//  Created by stplmacmini11 on 06/01/17.
//  Copyright © 2017 asdasd. All rights reserved.
//

#import "RouletteViewController.h"
#import "RouletteWheel.h"

@interface RouletteViewController () <RouletteWheelDelegate>

@property(weak, nonatomic) IBOutlet RouletteWheel *rouletteWheel;

@end

@implementation RouletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rouletteWheel.delegate = self;
}

@end
