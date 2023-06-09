//
//  Created by Yu JongCheol
//

import UIKit

class NewSwipeViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageData = [UIImage]()
    var currentPageLabel: UILabel!
    
    // for viewcontroller reuse
    var contentVCs = [Int: NewSwipeContentViewController]()
    
    // 현재 보고있는 페이지는?
    var currentContentViewController: NewSwipeContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let startingViewController: NewSwipeContentViewController = self.viewControllerAtIndex(pageData.count - 1)
        self.setViewControllers([startingViewController], direction: .forward, animated: false, completion: {done in })
        self.currentContentViewController = startingViewController
        
        // 레이블 변경.
        //self.currentPageLabel.isHidden = true
        self.setCurrentLable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(_ index: Int) -> NewSwipeContentViewController! {
        // reuse vcs.
        if let vc = self.contentVCs[index] {
            return vc
        } else {
            // Create a new view controller and pass suitable data.
            let contentViewController = UIStoryboard(name: "NewImageCrop", bundle: Bundle(for: Shared.self)).instantiateViewController(withIdentifier: "newswipeContent") as! NewSwipeContentViewController
            contentViewController.displayImage = self.pageData[index]
            contentViewController.pageIndex = index
            self.contentVCs.updateValue(contentViewController, forKey: index)
            return contentViewController
        }
        
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! NewSwipeContentViewController).pageIndex
            index -= 1
            if index == -1 {
                return nil
            }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! NewSwipeContentViewController).pageIndex
            index += 1
            if index == self.pageData.count {
                //index = 0
                return nil
            }
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let contentViewController = pageViewController.viewControllers![0] as! NewSwipeContentViewController
        
        self.currentContentViewController = contentViewController
        self.setCurrentLable()
    }
    

    func goNext(_ index: Int) {
        if let vc = self.viewControllerAtIndex(index) {
            self.currentContentViewController = vc
            self.setCurrentLable()
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goPrevious(_ index: Int) {
        if let vc = self.viewControllerAtIndex(index) {
            self.currentContentViewController = vc
            self.setCurrentLable()
            self.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setCurrentLable() {
        self.currentPageLabel.text = "\(self.currentContentViewController.pageIndex + 1)/\(self.pageData.count)"
    }
}
