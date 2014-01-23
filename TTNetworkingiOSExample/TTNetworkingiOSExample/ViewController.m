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
    TTHTTPRequest *_request;
    NSMutableArray *_requests;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _requests = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i = 0; i < 20; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 40, 320, 40)];
        label.numberOfLines = 2;
        [label setText:@"Hello World"];
        [self.view addSubview:label];
        self.view.backgroundColor = [UIColor whiteColor];
        
        TTHTTPRequest *request = [TTHTTPRequestFactory GET:@"http://www.baidu.com" parameters:nil success:^(TTHTTPRequest *request) {
            NSLog(@"viewController request success");
            [label setText:request.responseString];
        } failure:^(TTHTTPRequest *request) {
            NSLog(@"viewController request error:%@", request.error);
        }];
        [request start];
        [_requests addObject:request];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
