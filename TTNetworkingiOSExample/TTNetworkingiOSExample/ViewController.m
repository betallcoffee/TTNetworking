//
//  ViewController.m
//  TTNetworkingiOSExample
//
//  Created by liang on 1/5/14.
//  Copyright (c) 2014 liang. All rights reserved.
//

#import "ViewController.h"
#import "TTNetworking.h"

@interface ViewController ()
{
    NSMutableArray *_requests;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    for (int i = 0; i < 20; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 40, 320, 40)];
        label.numberOfLines = 2;
        [label setText:@"Hello World"];
        [self.view addSubview:label];
        self.view.backgroundColor = [UIColor whiteColor];
        
        [[TTHTTPClient sharedInstanced] GET:@"http://www.baidu.com" parameters:nil completion:^(TTHTTPRequest *request, NSError *error, BOOL isSuccess) {
            if (isSuccess) {
                NSLog(@"viewController request success %d", i);
                [label setText:request.responseString];
            } else {
                NSLog(@"viewController request error:%@", error);
            }
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
