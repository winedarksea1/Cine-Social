//
//  CircleView.swift
//  Cine-Social
//
//  Created by Andrew McGovern on 1/10/18.
//  Copyright © 2018 Andrew McGovern. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
