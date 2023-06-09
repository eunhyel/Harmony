import Foundation

public final class Core {
    
    public class var apple : Apple {
        struct Static {
            public static let instance : Apple = Apple()
        }
        return Static.instance
    }
    
}
