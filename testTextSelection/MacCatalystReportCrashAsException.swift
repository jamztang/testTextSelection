//
//  MacCatalystReportCrashAsException.swift
//
// Call installMacCatalystReportCrashAsException() from your App Delegate
//

import Foundation
import FirebaseCrashlytics

/// System exceptions are unhandled causing the app to crash.
/// We swizzle the `NSApplication._crashOnException:` to just log it to firebase and make it safe
func installMacCatalystReportCrashAsException() {
#if !targetEnvironment(macCatalyst)
    return
#endif

    if fixMacCatalystReportCrashAsException() {
        print("Successfully installed Mac Catalyst Report Crash as Exception")
    } else {
        print("Failed to install Mac Catalyst Report Crash as Exception")
    }
}

private var didInstallCrashFix = false

private func fixMacCatalystReportCrashAsException() -> Bool {
    guard let klass = NSClassFromString("NSApplication") else { return false }
    guard didInstallCrashFix == false else { return false }

    let sel = NSSelectorFromString("_crashOnException:")
    var origIMP: IMP?

    let newHandler: @convention(block) (AnyObject, AnyObject) -> Void = { blockSelf, exception in
        typealias ClosureType = @convention(c) (AnyObject, Selector, AnyObject) -> Void
        guard let exception = exception as? NSException else {
            fatalError()
        }

        let stackTrace = exception.callStackSymbols.map { callStack in
            let components = callStack.components(separatedBy: " ").filter { !$0.isEmpty }
            let stackFrame = StackFrame(symbol: components[3],
                                        file: components[1],
                                        line: Int(components[5]) ?? 0)
            return stackFrame
        }

        Crashlytics.crashlytics().setCustomValue(stackTrace, forKey: "mac_os_stacktrace")
        let errorModel = ExceptionModel(name: exception.name.rawValue,
                                        reason: exception.reason ?? "empty reason")
        errorModel.stackTrace = stackTrace

        // Note: ExceptionModel will always be reported as a non-fatal.
        Crashlytics.crashlytics().record(exceptionModel: errorModel)
        print("Recording this exception instead of crashing `\(exception)`")
        print(exception.callStackSymbols.joined(separator: "\n"))

        /// avoid calling to prevent crashing
        // let callableIMP = unsafeBitCast(origIMP, to: ClosureType.self)
        // callableIMP(blockSelf, sel, exception)
    }

    guard let method = class_getInstanceMethod(klass, sel) else { return false }
    origIMP = class_replaceMethod(klass, sel, imp_implementationWithBlock(newHandler), method_getTypeEncoding(method))

    didInstallCrashFix = true
    return origIMP != nil
}
