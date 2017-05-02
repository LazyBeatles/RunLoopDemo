//
//  Observer_TimerViewController.m
//  RunLoopTest
//
//  Created by liang on 2017/5/2.
//  Copyright © 2017年 __liang. All rights reserved.
//

#import "Observer_TimerViewController.h"

@interface Observer_TimerViewController () {
	CFRunLoopTimerRef _timer;
	NSThread *_thread;
}

@end

@implementation Observer_TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)addTimer_Observer:(id)sender {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		_thread = [NSThread currentThread];
		CFRunLoopRef runLoop = CFRunLoopGetCurrent();
		// timer上下文，第二个参数把self传过去，在回调函数中可以获取到
		CFRunLoopTimerContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
		// 初始换timer，并设置回调函数
		_timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 1, 1, 0, 0, &RunLoopTimerCallback, &context);
		// 添加到CommonModes
		CFRunLoopAddTimer(runLoop, _timer, kCFRunLoopCommonModes);
		
		/// building Params.
		NSDictionary *statusDictionary = @{@(kCFRunLoopEntry): @"即将进入RunLoop",
										   @(kCFRunLoopBeforeTimers): @"即将处理Timer",
										   @(kCFRunLoopBeforeSources): @"即将处理Source",
										   @(kCFRunLoopBeforeWaiting): @"即将进入休眠",
										   @(kCFRunLoopAfterWaiting): @"刚从休眠中唤醒",
										   @(kCFRunLoopExit): @"即将退出RunLoop"};
		// 需要监控的状态，这里我们监控所有状态
		CFRunLoopActivity activities = kCFRunLoopAllActivities;
		
		// 创建observer
		CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, activities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
			NSLog(@"%@", statusDictionary[@(activity)]);
		});
		// 把observer添加到runLoop
		CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
		CFRunLoopRun();
		
		// RunLoop退出才会执行
		CFRelease(_timer);
		NSLog(@"thread has stopped");
	});
}

- (IBAction)stop:(id)sender {
	[self performSelector:@selector(stopRunLoopTimer) onThread:_thread withObject:nil waitUntilDone:NO];
	_thread = nil;
}

#pragma mark - private methods
static void RunLoopTimerCallback(CFRunLoopTimerRef timer, void *info) {
	NSLog(@"info = %@", info);
}

- (void)stopRunLoopTimer {
	CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), _timer, kCFRunLoopCommonModes);
	CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
