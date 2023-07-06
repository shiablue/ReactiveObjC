//
//  RACTupleSpec.m
//  ReactiveObjC
//
//  Created by Justin Spahr-Summers on 2012-12-12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

@import Quick;
@import Nimble;

#import "RACTuple.h"
#import "RACUnit.h"

QuickSpecBegin(RACTupleSpec)

describe(@"RACTupleUnpack", ^{
	it(@"should unpack a single value", ^{
		RACTupleUnpack(RACUnit *value) = [RACTuple tupleWithObjects:RACUnit.defaultUnit, nil];
		expect(value).to(equal(RACUnit.defaultUnit));
	});

	it(@"should translate RACTupleNil", ^{
		RACTupleUnpack(id value) = [RACTuple tupleWithObjects:RACTupleNil.tupleNil, nil];
		expect(value).to(beNil());
	});

	it(@"should unpack multiple values", ^{
		RACTupleUnpack(NSString *str, NSNumber *num) = [RACTuple tupleWithObjects:@"foobar", @5, nil];

		expect(str).to(equal(@"foobar"));
		expect(num).to(equal(@5));
	});

	it(@"should fill in missing values with nil", ^{
		RACTupleUnpack(NSString *str, NSNumber *num) = [RACTuple tupleWithObjects:@"foobar", nil];

		expect(str).to(equal(@"foobar"));
		expect(num).to(beNil());
	});

	it(@"should skip any values not assigned to", ^{
		RACTupleUnpack(NSString *str, NSNumber *num) = [RACTuple tupleWithObjects:@"foobar", @5, RACUnit.defaultUnit, nil];

		expect(str).to(equal(@"foobar"));
		expect(num).to(equal(@5));
	});

	it(@"should keep an unpacked value alive when captured in a block", ^{
		__weak id weakPtr = nil;
		id (^block)(void) = nil;

		@autoreleasepool {
			RACTupleUnpack(NSString *str) = [RACTuple tupleWithObjects:[[NSMutableString alloc] init], nil];

			weakPtr = str;
			expect(weakPtr).notTo(beNil());

			block = [^{
				return str;
			} copy];
		}

		expect(weakPtr).notTo(beNil());
		expect(block()).to(equal(weakPtr));
	});
});

describe(@"RACTuplePack", ^{
	it(@"should pack a single value", ^{
		RACTuple *tuple = [RACTuple tupleWithObjects:RACUnit.defaultUnit, nil];
		expect(RACTuplePack(RACUnit.defaultUnit)).to(equal(tuple));
	});
	
	it(@"should translate nil", ^{
		RACTuple *tuple = [RACTuple tupleWithObjects:RACTupleNil.tupleNil, nil];
		expect(RACTuplePack(nil)).to(equal(tuple));
	});
	
	it(@"should pack multiple values", ^{
		NSString *string = @"foobar";
		NSNumber *number = @5;
		RACTuple *tuple = [RACTuple tupleWithObjects:string, number, nil];
		expect(RACTuplePack(string, number)).to(equal(tuple));
	});
});

describe(@"-tupleByAddingObject:", ^{
	__block RACTuple *tuple;

	beforeEach(^{
		tuple = RACTuplePack(@"foo", nil, @"bar");
	});

	it(@"should add a non-nil object", ^{
		RACTuple *newTuple = [tuple tupleByAddingObject:@"buzz"];
		expect(@(newTuple.count)).to(equal(@4));
		expect(newTuple[0]).to(equal(@"foo"));
		expect(newTuple[1]).to(beNil());
		expect(newTuple[2]).to(equal(@"bar"));
		expect(newTuple[3]).to(equal(@"buzz"));
	});

	it(@"should add nil", ^{
		RACTuple *newTuple = [tuple tupleByAddingObject:nil];
		expect(@(newTuple.count)).to(equal(@4));
		expect(newTuple[0]).to(equal(@"foo"));
		expect(newTuple[1]).to(beNil());
		expect(newTuple[2]).to(equal(@"bar"));
		expect(newTuple[3]).to(beNil());
	});

	it(@"should add NSNull", ^{
		RACTuple *newTuple = [tuple tupleByAddingObject:NSNull.null];
		expect(@(newTuple.count)).to(equal(@4));
		expect(newTuple[0]).to(equal(@"foo"));
		expect(newTuple[1]).to(beNil());
		expect(newTuple[2]).to(equal(@"bar"));
		expect(newTuple[3]).to(equal(NSNull.null));
	});
});

describe(@"RACTuple subclasses", ^{
	describe(@"equality to RACTuple", ^{
		context(@"RACOneTuple", ^{
			it(@"should be equal", ^{
				RACOneTuple *tupleSubclass = [RACOneTuple pack:@"foo"];
				RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[ @"foo" ]];
				expect(tupleSubclass).to(equal(tuple));
				expect(tuple).to(equal(tupleSubclass));
			});
		});

		context(@"RACTwoTuple", ^{
			it(@"should be equal", ^{
				RACTwoTuple *tupleSubclass = [RACTwoTuple pack:@"foo" :@"bar"];
				RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[ @"foo", @"bar" ]];
				expect(tupleSubclass).to(equal(tuple));
				expect(tuple).to(equal(tupleSubclass));
			});
		});

		context(@"RACThreeTuple", ^{
			it(@"should be equal", ^{
				RACThreeTuple *tupleSubclass = [RACThreeTuple pack:@"foo" :@"bar" :@"buzz"];
				RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[ @"foo", @"bar", @"buzz" ]];
				expect(tupleSubclass).to(equal(tuple));
				expect(tuple).to(equal(tupleSubclass));
			});
		});

		context(@"RACFourTuple", ^{
			it(@"should be equal", ^{
				RACFourTuple *tupleSubclass = [RACFourTuple pack:@"foo" :@"bar" :@"buzz" :@"fizz"];
				RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[ @"foo", @"bar", @"buzz", @"fizz" ]];
				expect(tupleSubclass).to(equal(tuple));
				expect(tuple).to(equal(tupleSubclass));
			});
		});

		context(@"RACFiveTuple", ^{
			it(@"should be equal", ^{
				RACFiveTuple *tupleSubclass = [RACFiveTuple pack:@"foo" :@"bar" :@"buzz" :@"fizz" :@"bizz"];
				RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[ @"foo", @"bar", @"buzz", @"fizz", @"bizz" ]];
				expect(tupleSubclass).to(equal(tuple));
				expect(tuple).to(equal(tupleSubclass));
			});
		});
	});

	describe(@"RACTuplePack", ^{
		context(@"RACOneTuple", ^{
			it(@"should be produced by packing", ^{
				expect(RACTuplePack(@"foo")).to(beAnInstanceOf(RACOneTuple.class));
			});
		});

		context(@"RACTwoTuple", ^{
			it(@"should be produced by packing", ^{
				expect(RACTuplePack(@"foo", @"bar")).to(beAnInstanceOf(RACTwoTuple.class));
			});
		});

		context(@"RACThreeTuple", ^{
			it(@"should be produced by packing", ^{
				expect(RACTuplePack(@"foo", @"bar", @"buzz")).to(beAnInstanceOf(RACThreeTuple.class));
			});
		});

		context(@"RACFourTuple", ^{
			it(@"should be produced by packing", ^{
				expect(RACTuplePack(@"foo", @"bar", @"buzz", @"fizz")).to(beAnInstanceOf(RACFourTuple.class));
			});
		});

		context(@"RACFiveTuple", ^{
			it(@"should be produced by packing", ^{
				expect(RACTuplePack(@"foo", @"bar", @"buzz", @"fizz", @"bizz")).to(beAnInstanceOf(RACFiveTuple.class));
			});
		});
	});

	describe(@"-tupleByAddingObject:", ^{
		context(@"RACOneTuple", ^{
			it(@"should produce a RACTwoTuple", ^{
				RACTwoTuple *tuple = [RACTuplePack(@"foo") tupleByAddingObject:@"buzz"];
				expect(tuple).to(beAnInstanceOf(RACTwoTuple.class));
			});
		});

		context(@"RACTwoTuple", ^{
			it(@"should produce a RACThreeTuple", ^{
				RACThreeTuple *tuple = [RACTuplePack(@"foo", @"bar") tupleByAddingObject:@"buzz"];
				expect(tuple).to(beAnInstanceOf(RACThreeTuple.class));
			});
		});

		context(@"RACThreeTuple", ^{
			it(@"should produce a RACFourTuple", ^{
				RACFourTuple *tuple = [RACTuplePack(@"foo", @"bar", @"buzz") tupleByAddingObject:@"fizz"];
				expect(tuple).to(beAnInstanceOf(RACFourTuple.class));
			});
		});

		context(@"RACFourTuple", ^{
			it(@"should produce a RACFiveTuple", ^{
				RACFiveTuple *tuple = [RACTuplePack(@"foo", @"bar", @"buzz", @"fizz") tupleByAddingObject:@"bizz"];
				expect(tuple).to(beAnInstanceOf(RACFiveTuple.class));
			});
		});
	});
});

QuickSpecEnd
