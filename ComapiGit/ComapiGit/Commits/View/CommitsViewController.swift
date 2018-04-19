//
//  CommitsViewController.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommitsViewController: BaseViewController {

    var commitsView: CommitsView { return view as! CommitsView }
    var viewModel: CommitsViewModel
    
    init(viewModel: CommitsViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        delegates()
        navigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CommitsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchCommits()
    }
    
    override func delegates() {
        commitsView.tableView.delegate = self
        commitsView.tableView.dataSource = self
        
        commitsView.didPullToRefresh = { [weak self] in
            guard let `self` = self else { return }
            if !self.viewModel.isLoading {
                self.viewModel.reset()
                self.rawReload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewModel.fetchCommits()
                }
            }
        }
        
        viewModel.didLoadAllResults = { [weak self] in
            guard let `self` = self else { return }
            self.hideLoader(from: self.commitsView.tableView)
        }
        
        viewModel.didFetchCommits = { [weak self] _ in
            self?.reloadViews()
        }
        
        viewModel.didFailCommitsLoad = { [weak self] error in
            self?.reloadViews()
        }
        
        viewModel.didStartCommentsLoad = { [weak self] indexPath in
            if let cell = self?.commitsView.tableView.cellForRow(at: indexPath) as? CommitTableViewCell {
                cell.startLoader()
            }
        }
        
        viewModel.didFetchComments = { [weak self] _, indexPath in
            self?.reloadComments(atIndexPath: indexPath)
        }
        
        viewModel.didFailCommentsLoad = { [weak self] error in
            self?.reloadViews()
        }
    }
    
    override func navigation() {
        title = "Commit \(viewModel.repo.name)"
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func reloadComments(atIndexPath indexPath: IndexPath) {
        if let cell = commitsView.tableView.cellForRow(at: indexPath) as? CommitTableViewCell {
            cell.stopLoader()
        }
        commitsView.tableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .none)
    }
    
    func rawReload() {
        commitsView.tableView.reloadData()
    }
    
    func reloadViews() {
        hideLoader(from: commitsView.tableView)
        commitsView.toggleRefresh(refresh: false)
        commitsView.tableView.reloadData()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.commits.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.commits[section].showComments ? viewModel.commits[section].comments.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as? CommitTableViewCell {
                let commit = viewModel.commits[indexPath.section]
                cell.configure(withCommit: commit, downloader: viewModel.downloader)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell {
                let comment = viewModel.commits[indexPath.section].comments[indexPath.row - 1]
                cell.configure(withComment: comment, downloader: viewModel.downloader)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if viewModel.commits[indexPath.section].comments.count == 0 {
                viewModel.commits[indexPath.section].showComments = true
            } else {
                viewModel.commits[indexPath.section].showComments = !viewModel.commits[indexPath.row].showComments
            }
            
            if viewModel.commits[indexPath.section].showComments {
                viewModel.fetchComments(atIndexPath: indexPath)
            } else {
                viewModel.commits[indexPath.section].comments = []
                reloadComments(atIndexPath: indexPath)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 100) {
            if !viewModel.isLoading {
                showLoader(in: commitsView.tableView)
                viewModel.fetchCommits()
            }
        }
    }
}
