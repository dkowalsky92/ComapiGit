//
//  BaseView.swift
//  RSSFeed
//
//  Created by Dominik Kowalski on 18/03/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import SnapKit

class BaseView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.backgroundColor = Colors.cadetGray()
    }
    
    func customize(_ view: UIView) {}
    
    func layout(_ view: UIView) {}
    
    func constrain(_ view: UIView) {}
}
