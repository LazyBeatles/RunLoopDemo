//
//  RunLoopViewController.m
//  RunLoopTest
//
//  Created by liang on 2017/5/2.
//  Copyright © 2017年 __liang. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController () {
	CFRunLoopSourceRef _source;
	NSThread *_thread;
}

@end

@implementation RunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)createRunLoop:(id)sender {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		_thread = [NSThread currentThread];
		[self createRunLoop];
	});
}

- (IBAction)wakeUpRunLoop:(id)sender {
	[self performSelector:@selector(wakeUp) onThread:_thread withObject:nil waitUntilDone:NO];
}

- (IBAction)stopRunLoop:(id)sender {
	[self performSelector:@selector(stop) onThread:_thread withObject:nil waitUntilDone:NO];
	NSLog(@"thread should be stopped");
}

#pragma mark - private methods
- (void)createRunLoop {
	NSLog(@"create RunLoop");
	@autoreleasepool {
		// source上下文
		CFRunLoopSourceContext context = {0};
		// 指定事件回调
		context.perform = RunLoopCallback;
		// 为source添加事件
		_source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
		// source添加到RunLoop
		CFRunLoopAddSource(CFRunLoopGetCurrent(), _source, kCFRunLoopCommonModes);
		// 监听事件知道RunLoop停止
		CFRunLoopRun();
		
		// 停止RunLoop的时候，移除source
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), _source, kCFRunLoopCommonModes);
		CFRelease(_source);
		NSLog(@"RunLoop has stopped");
	}
}

static void RunLoopCallback(void *info) {
	NSLog(@"do something");
}

- (void)wakeUp {
	CFRunLoopSourceSignal(_source);
	CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

- (void)stop {
	CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
