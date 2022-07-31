//
// Created by Łukasz Kasperek on 31/07/2022.
//

import Foundation

class PaceValueTransformer: ValueTransformer {
    static func register() {
        let transformer = PaceValueTransformer()
        ValueTransformer.setValueTransformer(
                transformer,
                forName: NSValueTransformerName("PaceValueTransformer")
        )
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let components = (value as? Pace)?.components else {
            return nil
        }
        return components.withUnsafeBufferPointer { bufferPointer in
            Data(buffer: bufferPointer)
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        let intArray = data.withUnsafeBytes { rawBufferPointer in
            let typedPointer = rawBufferPointer.assumingMemoryBound(to: Int.self)
            return Array(typedPointer)
        }
        return Pace(components: intArray)
    }
}
