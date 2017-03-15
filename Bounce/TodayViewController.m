//
//  TodayViewController.m
//  Bounce
//
//  Created by stplmacmini11 on 11/01/17.
//  Copyright © 2017 asdasd. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(rotationTimer:) userInfo:nil repeats:YES];
}

- (void)rotationTimer:(NSTimeInterval)time {
    [UIView animateWithDuration:0.49 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        [_imageView setFrame:CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width - 10, _imageView.frame.size.height - 10)];
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    [self rotationTimer:0];

    completionHandler(NCUpdateResultNewData);
}

@end
