//
//  Created by Yu JongCheol
//

import UIKit

class NewSwipeContentViewController: UIViewController {
    
    @IBOutlet weak var centerImage: UIImageView!
    
    var displayImage: UIImage!
    var pageIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.centerImage.image = displayImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
