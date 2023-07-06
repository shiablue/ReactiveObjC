//
//  UIDatePicker+RACSignalSupport.h
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

@interface UIDatePicker (RACSignalSupport)

/// Creates a new RACChannel-based binding to the receiver.
///
/// nilValue - The date to set when the terminal receives `nil`.
///
/// Returns a RACChannelTerminal that sends the receiver's date whenever the
/// UIControlEventValueChanged control event is fired, and sets the date to the
/// values it receives.
- (RACChannelTerminal<NSDate *> *)rac_newDateChannelWithNilValue:(nullable NSDate *)nilValue;

@end

NS_ASSUME_NONNULL_END

#endif
