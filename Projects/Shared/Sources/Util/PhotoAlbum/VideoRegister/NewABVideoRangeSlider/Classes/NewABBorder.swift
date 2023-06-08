//
//  ABBorder.swift
//  selfband
//
//  Created by Oscar J. Irun on 27/11/16.
//  Copyright © 2016 appsboulevard. All rights reserved.
//

import UIKit

class NewABBorder: UIView {
    
    let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        line.backgroundColor = UIColor(redF: 255, greenF: 68, blueF: 114)
        line.frame = self.bounds
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.frame = self.bounds
    }

}
