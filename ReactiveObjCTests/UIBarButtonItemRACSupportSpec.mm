//
//  UIBarButtonItemRACSupportSpec.m
//  ReactiveObjC
//
//  Created by Kyle LeNeau on 4/13/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

@import Quick;
@import Nimble;

#import "RACControlCommandExamples.h"

#import "UIBarButtonItem+RACCommandSupport.h"
#import "RACCommand.h"
#import "RACDisposable.h"

QuickSpecBegin(UIBarButtonItemRACSupportSpec)

describe(@"UIBarButtonItem", ^{
	__block UIBarButtonItem *button;
	
	beforeEach(^{
		button = [[UIBarButtonItem alloc] init];
		expect(button).notTo(beNil());
	});

	itBehavesLike(RACControlCommandExamples, ^{
		return @{
			RACControlCommandExampleControl: button,
			RACControlCommandExampleActivateBlock: ^(UIBarButtonItem *button) {
				NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[button.target methodSignatureForSelector:button.action]];
				invocation.selector = button.action;

				id target = button.target;
				[invocation setArgument:&target atIndex:2];
				[invocation invokeWithTarget:target];
			}
		};
	});
});

QuickSpecEnd
