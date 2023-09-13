import Foundation

public final class Core {
    
    public class var apple : Apple {
        struct Static {
            public static let instance : Apple = Apple()
        }
        return Static.instance
    }
    
}

public extension Array where Element == BoxList {
    var toUniqueByMemNo: [Element] {
        var filtered: [Element] = []
        
        for i in self {
            if filtered.contains(where: { $0.memNo == i.memNo }) == false {
                filtered.append(i)
            }
        }
        
        return filtered
    }
}
