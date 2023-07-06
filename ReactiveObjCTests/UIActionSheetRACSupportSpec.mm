//
//  UIActionSheetRACSupportSpec.m
//  ReactiveObjC
//
//  Created by Dave Lee on 2013-06-22.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0

@import Quick;
@import Nimble;

#import "RACSignal.h"
#import "RACSignal+Operations.h"
#import "UIActionSheet+RACSignalSupport.h"

QuickSpecBegin(UIActionSheetRACSupportSpec)

describe(@"-rac_buttonClickedSignal", ^{
	__block UIActionSheet *actionSheet;

	beforeEach(^{
		actionSheet = [[UIActionSheet alloc] init];
		[actionSheet addButtonWithTitle:@"Button 0"];
		[actionSheet addButtonWithTitle:@"Button 1"];
		expect(actionSheet).notTo(beNil());
	});

	it(@"should send the index of the clicked button", ^{
		__block NSNumber *index = nil;
		[actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *i) {
			index = i;
		}];

		[actionSheet.delegate actionSheet:actionSheet clickedButtonAtIndex:1];
		expect(index).to(equal(@1));
	});
});

QuickSpecEnd

#endif 
