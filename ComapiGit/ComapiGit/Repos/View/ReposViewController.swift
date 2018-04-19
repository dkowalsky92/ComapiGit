//
//  ReposViewController.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReposViewController: BaseViewController {
    
    var reposView: ReposView { return view as! ReposView }
    var viewModel: ReposViewModel
    
    init(viewModel: ReposViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        delegates()
        navigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ReposView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchRepos()
    }
    
    override func delegates() {
        reposView.tableView.delegate = self
        reposView.tableView.dataSource = self
        
        reposView.didPullToRefresh = { [weak self] in
            guard let `self` = self else { return }
            if !self.viewModel.isLoading {
                self.viewModel.reset()
                self.rawReload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewModel.fetchRepos()
                }
            }
        }
        
        viewModel.didLoadAllResults = { [weak self] in
            guard let `self` = self else { return }
            self.hideLoader(from: self.reposView.tableView)
        }
        
        viewModel.didFetchRepos = { [weak self] _ in
            self?.reloadViews()
        }
        
        viewModel.didFailReposLoad = { [weak self] error in
            self?.reloadViews()
        }
    }
    
    override func navigation() {
        title = "Repositories"
    }
    
    func rawReload() {
        reposView.tableView.reloadData()
    }
    
    func reloadViews() {
        hideLoader(from: reposView.tableView)
        reposView.toggleRefresh(refresh: false)
        reposView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
    }
}

extension ReposViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReposTableViewCell {
            let repo = viewModel.repos[indexPath.row]
            cell.configure(withRepo: repo)
            cell.didTapCommitsButton = { [weak self] in
                let vm = CommitsViewModel(repo: repo)
                let vc = CommitsViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.didTapReleasesButton = { [weak self] in
                let vm = ReleasesViewModel(repo: repo)
                let vc = ReleasesViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            cell.didTapUrlButton = { 
                guard let url = URL(string: repo.htmlUrl) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            cell.switchToCompact()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReposTableViewCell {
            cell.toggleState()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 100){
            if !viewModel.isLoading {
                showLoader(in: reposView.tableView)
                viewModel.fetchRepos()
            }
        }
    }
}
