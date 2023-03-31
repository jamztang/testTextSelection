//
//  NSApplication+CrashReporting.m
//  testTextSelection
//
//  Created by James Tang on 31/3/2023.
//

#import "NSApplication+CrashReporting.h"
#import <objc/runtime.h>
@import FirebaseCrashlytics;

@interface NSArray (Map)
- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;
@end

/// Cannot extend NSApplication in Swift so we have to use Objective-C here
@implementation NSApplication (CrashReporting)

+(void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        SEL crashOnExceptionSelector = NSSelectorFromString(@"_crashOnException:"); // Ignore 'Undeclared selector' warning.
        SEL crashOnExceptionReporterSelector = @selector(reported__crashOnException:);
        Method originalMethod = class_getInstanceMethod(self, crashOnExceptionSelector);
        Method extendedMethod = class_getInstanceMethod(self, crashOnExceptionReporterSelector);
        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

- (void)reported__crashOnException:(NSException*)exception {
    NSArray<NSString *> *stacktrace = [exception callStackSymbols];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;

    // map stacktrace into `FIRStackFrame` properly
    NSArray<FIRStackFrame *> *stackframes = [stacktrace mapObjectsUsingBlock:^id(NSString *obj, NSUInteger idx) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSString *string = (NSString *)evaluatedObject;
            return [string length] != 0;
        }];
        NSArray *components = [[obj componentsSeparatedByString:@" "] filteredArrayUsingPredicate:predicate];
        NSNumber *line = [f numberFromString:components[5]];
        FIRStackFrame *stackFrame = [FIRStackFrame stackFrameWithSymbol:components[3]
                                              file:components[1]
                                              line:[line integerValue]
        ];
        return stackFrame;
    }];
    [[FIRCrashlytics crashlytics] setCustomValue:stacktrace forKey:@"mac_os_stacktrace"];
    FIRExceptionModel *errorModel = [FIRExceptionModel exceptionModelWithName:exception.name reason:exception.reason];
    // The below stacktrace is hardcoded as an example, in an actual solution you should parse the stacktrace array entries.
    errorModel.stackTrace = stackframes;

    // Note: ExceptionModel will always be reported as a non-fatal.
    [[FIRCrashlytics crashlytics] recordExceptionModel:errorModel];
    [self reported__crashOnException:exception]; // this will crash the app according to the original implementation
}
@end

@implementation NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

@end
