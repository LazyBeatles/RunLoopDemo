//
//  ContrastViewController.m
//  RunLoopTest
//
//  Created by liang on 2017/5/2.
//  Copyright © 2017年 __liang. All rights reserved.
//

#import "ContrastViewController.h"

@interface ContrastViewController ()

@end

@implementation ContrastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)mainThread:(id)sender {
	NSLog(@"主线程RunLoop测试");
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	// 当前runLoop一直休眠，直到被唤醒
	[runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	// 主线程有监听，比如点击事件，将会唤醒RunLoop，唤醒后打印
	NSLog(@"主线程RunLoop被唤醒接着跑");
}

- (IBAction)subThread:(id)sender {
	NSLog(@"次线程RunLoop测试");
	__block NSInteger count = 0;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		while (count < 5) {
			NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
			// 当前runLoop一直休眠，直到被唤醒
			[runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
			// RunLoop必须要有一个Timer、Observer、Source，否则RunLoop直接退出，直接打印
			NSLog(@"次线程没有被暂停");
			count += 1;
		}
	});
}

- (IBAction)test:(id)sender {
	NSLog(@"你点击了");
}

@end
