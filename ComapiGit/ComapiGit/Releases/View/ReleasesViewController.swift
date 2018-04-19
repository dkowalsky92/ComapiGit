//
//  ReleasesViewController.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReleasesViewController: BaseViewController {

    var releasesView: ReleasesView { return view as! ReleasesView }
    var viewModel: ReleasesViewModel
    
    init(viewModel: ReleasesViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        delegates()
        navigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ReleasesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchReleases()
    }
    
    override func delegates() {
        releasesView.tableView.delegate = self
        releasesView.tableView.dataSource = self
        
        releasesView.didPullToRefresh = { [weak self] in
            guard let `self` = self else { return }
            if !self.viewModel.isLoading {
                self.viewModel.reset()
                self.rawReload()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.viewModel.fetchReleases()
                }
            }
        }
        
        viewModel.didLoadAllResults = { [weak self] in
            guard let `self` = self else { return }
            self.hideLoader(from: self.releasesView.tableView)
        }

        viewModel.didFetchReleases = { [weak self] _ in
            self?.reloadViews()
        }
        
        viewModel.didFailReleasesLoad = { [weak self] error in
            self?.reloadViews()
        }
    }
    
    override func navigation() {
        title = "Release \(viewModel.repo.name)"
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func rawReload() {
        releasesView.tableView.reloadData()
    }
    
    func reloadViews() {
        hideLoader(from: releasesView.tableView)
        releasesView.toggleRefresh(refresh: false)
        releasesView.tableView.reloadData()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension ReleasesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.releases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ReleasesTableViewCell {
            let release = viewModel.releases[indexPath.row]
            cell.configure(withRelease: release, downloader: viewModel.downloader)
            cell.didTapUrlButton = {
                guard let url = URL(string: release.htmlUrl) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height + 100) {
            if !viewModel.isLoading {
                showLoader(in: releasesView.tableView)
                viewModel.fetchReleases()
            }
        }
    }
}

