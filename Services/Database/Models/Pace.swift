//
// Created by Łukasz Kasperek on 31/07/2022.
//

import Foundation

public class Pace: NSObject {
    public let components: [Int]
    
    public init(components: [Int]) {
        self.components = components
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? Pace else { return false }
        return other.components == components
    }
}
