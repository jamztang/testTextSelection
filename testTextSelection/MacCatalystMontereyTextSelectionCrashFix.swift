//
//  MontereyTextSelectionCrashFix.swift
//  testTextSelection
//
//  Created by James Tang on 30/3/2023.
//
//
// Call installMoneteryAppKitTextCrashFix() from your App Delegate
//

import MachO
import Foundation

/// Text input can crash in Mac Catalyst due to a property not being atomic.
/// We swizzle the `getCharacters:range:` to make it safe
func installMontereyTextSelectionCrashFix() {
#if !targetEnvironment(macCatalyst)
    return
#endif

    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    guard osVersion.majorVersion == 12 else {
        // Only apply this fix on Monterey
        return
    }

    if fixMontereyTextSelectionCrash() {
        print("Successfully installed Mac Monterey Text Selection Fix.")
    }
}

private var didInstallCrashFix = false

private func fixMontereyTextSelectionCrash() -> Bool {
    guard let oriClass = NSClassFromString("NSTaggedPointerString") else { return false }
    guard let newClass = NSClassFromString("NSString") else { return false }
    guard didInstallCrashFix == false else { return false }

    let oriSel = NSSelectorFromString("getCharacters:range:")
    let newSel = NSSelectorFromString("safeGetCharacters:range:")
    if let originalMethod = class_getInstanceMethod(oriClass, oriSel),
       let swizzledMethod = class_getInstanceMethod(newClass, newSel) {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    didInstallCrashFix = true
    return didInstallCrashFix
}

public extension NSString {
    @objc func safeGetCharacters(_ buffer: UnsafeMutablePointer<unichar>, range: NSRange) {
        if range.location + range.length > self.length {
            print("TTT out of bounds, prevent crash")
        } else {
            self.safeGetCharacters(buffer, range: range) // original implementation
        }
    }
}
