//
//  Copyright © 2017 Bowtie. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

@objc(FKFlag)
public class Flag: NSObject {
    /**
     Country code of the flag
     */
    public let countryCode: String

    #if os(iOS) || os(tvOS)
        /**
         Original unstyled flag image
         */
        public let originalImage: UIImage

        /**
         Returns a flag if the country code is supported, otherwise it returns nil
         */
        public init?(countryCode: String) {
            guard let image = UIImage(named: countryCode, in: FlagKit.assetBundle, compatibleWith: nil) else {
                return nil
            }

            self.countryCode = countryCode
            originalImage = image
        }

        /**
         Returns a styled flag according to the provided style
         - parameter style: Desired flag style
         */
        public func image(style: FlagStyle) -> UIImage {
            return originalImage.rendereredImage(size: style.size, action: { context in
                switch style {
                case .none:
                    break
                case .roundedRect:
                    let path = UIBezierPath(roundedRect: context.format.bounds, cornerRadius: 2)
                    path.addClip()
                case .square:
                    let path = UIBezierPath(rect: context.format.bounds)
                    path.addClip()
                case .circle:
                    let path = UIBezierPath(roundedRect: context.format.bounds, cornerRadius: style.size.width)
                    path.addClip()
                }
            })
        }

    #elseif os(macOS)
        /**
         Original unstyled flag image
         */
        public let originalImage: NSImage

        /**
         Returns a flag if the country code is supported, otherwise it returns nil
         */
        public init?(countryCode: String) {
            guard let image = FlagKit.assetBundle.image(forResource: countryCode) else {
                return nil
            }

            self.countryCode = countryCode
            originalImage = image
        }
    #endif
}
