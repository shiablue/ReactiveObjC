//
//  NSObject+RACDeallocating.m
//  ReactiveObjC
//
//  Created by Kazuo Koga on 2013/03/15.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "NSObject+RACDeallocating.h"
#import "RACCompoundDisposable.h"
#import "RACDisposable.h"
#import "RACReplaySubject.h"
#import <objc/message.h>
#import <objc/runtime.h>

static const void *RACObjectCompoundDisposable = &RACObjectCompoundDisposable;

static NSMutableSet *swizzledClasses() {
	static dispatch_once_t onceToken;
	static NSMutableSet *swizzledClasses = nil;
	dispatch_once(&onceToken, ^{
		swizzledClasses = [[NSMutableSet alloc] init];
	});

	return swizzledClasses;
}

static void swizzleDeallocIfNeeded(Class classToSwizzle) {
	@synchronized (swizzledClasses()) {
		NSString *className = NSStringFromClass(classToSwizzle);
		if ([swizzledClasses() containsObject:className]) return;

		typedef void (*objc_msgSendSuper_t)(struct objc_super *super, SEL op, ...);
		typedef void (*objc_msgSend_t)(id, SEL, ...);

		const char *types = "v@:";
		SEL deallocSelector = sel_registerName("dealloc");
		__block IMP originalDealloc = NULL;
		
		IMP newDealloc = imp_implementationWithBlock(^(__unsafe_unretained id self, va_list args) {
			RACCompoundDisposable *compoundDisposable = objc_getAssociatedObject(self, RACObjectCompoundDisposable);
			[compoundDisposable dispose];

			((objc_msgSend_t)originalDealloc)(self, deallocSelector, args);
		});

		originalDealloc = class_replaceMethod(classToSwizzle, deallocSelector, newDealloc, types);

		// just call super if classToSwizzle doesn't overrite deaaloc method
		if (!originalDealloc) {
			originalDealloc = imp_implementationWithBlock(^(__unsafe_unretained id self, va_list args) {
				objc_super super = { self, class_getSuperclass(classToSwizzle) };
				((objc_msgSendSuper_t)objc_msgSendSuper)(&super, deallocSelector, args);
			});
		}

		[swizzledClasses() addObject:className];
	}
}

@implementation NSObject (RACDeallocating)

- (RACSignal *)rac_willDeallocSignal {
	@synchronized (self) {
		RACSignal *signal = objc_getAssociatedObject(self, _cmd);
		if (signal != nil) return signal;

		RACReplaySubject *subject = [RACReplaySubject subject];

		[self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
			[subject sendCompleted];
		}]];

		objc_setAssociatedObject(self, _cmd, subject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

		return subject;
	}
}

- (RACCompoundDisposable *)rac_deallocDisposable {
	@synchronized (self) {
		RACCompoundDisposable *compoundDisposable = objc_getAssociatedObject(self, RACObjectCompoundDisposable);
		if (compoundDisposable != nil) return compoundDisposable;

		swizzleDeallocIfNeeded(self.class);

		compoundDisposable = [RACCompoundDisposable compoundDisposable];
		objc_setAssociatedObject(self, RACObjectCompoundDisposable, compoundDisposable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

		return compoundDisposable;
	}
}

@end
