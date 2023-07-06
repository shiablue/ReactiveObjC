//
//  NSURLConnectionRACSupportSpec.m
//  ReactiveObjC
//
//  Created by Justin Spahr-Summers on 2013-10-01.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_11 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_9_0 || __TVOS_VERSION_MIN_REQUIRED < __TVOS_9_0

@import Quick;
@import Nimble;

#import "NSURLConnection+RACSupport.h"
#import "RACSignal+Operations.h"
#import "RACTuple.h"

QuickSpecBegin(NSURLConnectionRACSupportSpec)

it(@"should fetch a JSON file", ^{
	NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"test-data" withExtension:@"json"];
	expect(fileURL).notTo(beNil());

	NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];

	BOOL success = NO;
	NSError *error = nil;
	RACTuple *result = [[NSURLConnection rac_sendAsynchronousRequest:request] firstOrDefault:nil success:&success error:&error];
	expect(@(success)).to(beTruthy());
	expect(error).to(beNil());
	expect(result).to(beAKindOf(RACTuple.class));

	NSURLResponse *response = result.first;
	expect(response).to(beAKindOf(NSURLResponse.class));

	NSData *data = result.second;
	expect(data).to(beAKindOf(NSData.class));
	expect(data).to(equal([NSData dataWithContentsOfURL:fileURL]));
});

QuickSpecEnd

#endif 
