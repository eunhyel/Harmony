/*********************************************
 *
 * This code is under the MIT License (MIT)
 *
 * Copyright (c) 2016 AliSoftware
 *
 *********************************************/

#if canImport(UIKit)
import UIKit

// MARK: Protocol Definition

/// Make your UIViewController subclasses conform to this protocol when:
///  * they *are* Storyboard-based, and
///  * this ViewController is the initialViewController of your Storyboard
///
/// to be able to instantiate them from the Storyboard in a type-safe manner
public protocol StoryboardBased: AnyObject {
  /// The UIStoryboard to use when we want to instantiate this ViewController
  static var sceneStoryboard: UIStoryboard { get }
    
    /// from Honey
    static var storyboardFileName: String { get }
    static var storyboardFromName: UIStoryboard { get }
}

// MARK: Default Implementation

public extension StoryboardBased {
  /// By default, use the storybaord with the same name as the class
  static var sceneStoryboard: UIStoryboard {
    return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
  }
    
    static var storyboardFileName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static var storyboardFromName: UIStoryboard {
        return UIStoryboard(name: storyboardFileName, bundle: Bundle(for: self))
    }
    
}

// MARK: Support for instantiation from Storyboard

public extension StoryboardBased where Self: UIViewController {
  /**
   Create an instance of the ViewController from its associated Storyboard's initialViewController

   - returns: instance of the conforming ViewController
   */
  static func instantiate() -> Self {
    let viewController = sceneStoryboard.instantiateInitialViewController()
    guard let typedViewController = viewController as? Self else {
      fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
    }
    return typedViewController
  }
    
    static func instantiate(_ bundle: Bundle? = nil) -> Self {
        let fileName = storyboardFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        
        return vc
        
    }
    
    static func instantiate(name: String, _ bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        
        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(name)")
        }
        
        return vc
    }
}
#endif
