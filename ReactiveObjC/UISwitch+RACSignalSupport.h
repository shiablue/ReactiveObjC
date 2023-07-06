//
//  UISwitch+RACSignalSupport.h
//  ReactiveObjC
//
//  Created by Uri Baghin on 20/07/2013.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import <TargetConditionals.h>

#if !TARGET_OS_OSX && !TARGET_OS_WATCH

#import <UIKit/UIKit.h>

@class RACChannelTerminal<ValueType>;

NS_ASSUME_NONNULL_BEGIN

@interface UISwitch (RACSignalSupport)

/// Creates a new RACChannel-based binding to the receiver.
///
/// Returns a RACChannelTerminal that sends whether the receiver is on whenever
/// the UIControlEventValueChanged control event is fired, and sets it on or off
/// when it receives @YES or @NO respectively.
- (RACChannelTerminal<NSNumber *> *)rac_newOnChannel;

@end

NS_ASSUME_NONNULL_END

#endif
