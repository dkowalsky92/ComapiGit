//
//  ActionButton.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    let color: UIColor
    let title: String
    
    init(color: UIColor, title: String) {
        self.color = color
        self.title = title
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        backgroundColor = color
        setTitle(title, for: UIControlState())
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .light)
        titleLabel?.numberOfLines = 0
    }
}
