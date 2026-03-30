import Foundation

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("InAppPurchaseKit_InAppPurchaseKit.bundle").path
        let buildPath = "/Users/vincent/Desktop/PersonalProject/InAppPurchaseKit/.build/arm64-apple-macosx/debug/InAppPurchaseKit_InAppPurchaseKit.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            // Users can write a function called fatalError themselves, we should be resilient against that.
            Swift.fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}