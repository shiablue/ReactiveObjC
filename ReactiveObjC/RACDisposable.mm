//
//  RACDisposable.m
//  ReactiveObjC
//
//  Created by Josh Abernathy on 3/16/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import "RACDisposable.h"
#import "RACScopedDisposable.h"
#import <stdatomic.h>

@interface RACDisposable () {
	// A copied block of type void (^)(void) containing the logic for disposal,
	// a pointer to `self` if no logic should be performed upon disposal, or
	// NULL if the receiver is already disposed.
	//
	// This should only be used atomically.
	_Atomic(void *) _disposeBlock;
}

@end

@implementation RACDisposable

#pragma mark Properties

- (BOOL)isDisposed {
	return _disposeBlock == NULL;
}

#pragma mark Lifecycle

- (instancetype)init {
	if (self = [super init]) {
		atomic_store(&_disposeBlock, (__bridge void *)self);
	}

	return self;
}

- (instancetype)initWithBlock:(void (^)(void))block {
	NSCParameterAssert(block != nil);

	if (self = [super init]) {
		atomic_store(&_disposeBlock, (void *)CFBridgingRetain([block copy]));
	}

	return self;
}

+ (instancetype)disposableWithBlock:(void (^)(void))block {
	return [(RACDisposable *)[self alloc] initWithBlock:block];
}

- (void)dealloc {
	void *blockPtr = atomic_load(&_disposeBlock);
	if (blockPtr == NULL || blockPtr == (__bridge void *)self) return;

	CFRelease(blockPtr);
	atomic_store(&_disposeBlock, NULL);
}

#pragma mark Disposal

- (void)dispose {
	void (^disposeBlock)(void) = NULL;

	while (YES) {
		void *blockPtr = _disposeBlock;
		if (atomic_compare_exchange_strong(&_disposeBlock, &blockPtr, NULL)) {
			if (blockPtr != (__bridge void *)self) {
				disposeBlock = CFBridgingRelease(blockPtr);
			}

			break;
		}
	}

	if (disposeBlock != nil) disposeBlock();
}

#pragma mark Scoped Disposables

- (RACScopedDisposable *)asScopedDisposable {
	return [RACScopedDisposable scopedDisposableWithDisposable:self];
}

@end
