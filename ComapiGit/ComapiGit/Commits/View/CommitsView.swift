//
//  CommitsView.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommitsView: BaseView {

    let refreshControl: UIRefreshControl
    let tableView: UITableView
    
    var didPullToRefresh: (() -> ())?
    
    override init() {
        refreshControl = UIRefreshControl(frame: .zero)
        tableView = UITableView()
        
        super.init()
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        customize(self)
        customize(tableView)
        customize(refreshControl)
        
        layout(tableView)
        
        constrain(tableView)
    }
    
    override func customize(_ view: UIView) {
        switch view {
        case self:
            backgroundColor = Colors.cadetGray()
        case tableView:
            tableView.backgroundColor = Colors.cadetGray()
            tableView.backgroundView?.backgroundColor = Colors.cadetGray()
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
            tableView.register(CommitTableViewCell.self, forCellReuseIdentifier: "commitCell")
            tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
            tableView.refreshControl = refreshControl
        case refreshControl:
            refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
            refreshControl.tintColor = Colors.isabellineWhite()
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [.foregroundColor : Colors.isabellineWhite(),
                                                                                                      .font : UIFont.italicSystemFont(ofSize: 14)])
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        switch view {
        default:
            addSubview(view)
        }
    }
    
    override func constrain(_ view: UIView) {
        view.snp.makeConstraints {
            switch view {
            case tableView:
                $0.edges.equalToSuperview()
            default:
                break
            }
        }
    }
    
    func toggleRefresh(refresh: Bool) {
        if refresh {
            refreshControl.beginRefreshing()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshTableView() {
        didPullToRefresh?()
    }

}
