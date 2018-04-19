//
//  CommitsViewModel.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommitsViewModel: BaseViewModel {
    
    let interactor: CommitsInteractor
    var commits: [Commit]
    var repo: Repository
    var downloader: ImageDownloader
    
    var commitPaging: Paging
    var commentPaging: Paging
    var loadingComplete = false
    
    var didLoadAllResults: (() -> ())?
    
    var didFetchCommits: ((_ commits: [Commit]) -> ())?
    var didFailCommitsLoad: ((Error?) -> ())?
    
    var didStartCommentsLoad: ((_ indexPath: IndexPath) -> ())?
    var didFetchComments: ((_ comments: [Comment], _ indexPath: IndexPath) -> ())?
    var didFailCommentsLoad: ((Error?) -> ())?
    
    var isLoading = false
    
    init(repo: Repository) {
        interactor = CommitsInteractor(timeout: 10.0)
        downloader = ImageDownloader()
        commits = []
        
        let next = Paging.Values(page: 1, perPage: 10)
        let last = Paging.Values(page: 1, perPage: 10)
        commitPaging = Paging(next: next, last: last)
        commentPaging = Paging(next: next, last: last)
        
        self.repo = repo
        
        super.init()
    }
    
    func reset() {
        commits = []
        let next = Paging.Values(page: 1, perPage: 10)
        let last = Paging.Values(page: 1, perPage: 10)
        commitPaging = Paging(next: next, last: last)
        commentPaging = Paging(next: next, last: last)
        loadingComplete = false
    }
    
    func fetchCommits() {
        if loadingComplete {
            didLoadAllResults?()
            return
        }
        isLoading = true
        interactor.fetchCommits(forRepo: repo, page: commitPaging.next.page, perPage: commitPaging.next.perPage, completion: { [weak self] commits, paging in
            if paging != nil {
                if self?.commitPaging.next.page == paging!.last.page {
                    self?.loadingComplete = true
                }
                self?.commitPaging.next = paging!.next
                self?.commitPaging.last = paging!.last
            } else {
                self?.loadingComplete = true
            }
            
            self?.commits.append(contentsOf: commits)
            self?.didFetchCommits?(commits)
            self?.isLoading = false
        }) { [weak self] error in
            self?.didFailCommitsLoad?(error)
            self?.isLoading = false
        }
    }
    
    func fetchComments(atIndexPath indexPath: IndexPath) {
        isLoading = true
        didStartCommentsLoad?(indexPath)
        let commit = commits[indexPath.section]
        interactor.fetchComments(forRepo: repo, commit: commit, page: commentPaging.next.page, perPage: commentPaging.next.perPage, completion: { [weak self] comments, paging in
            guard let `self` = self else { return }
            if paging != nil {
                self.commentPaging.next = paging!.next
                self.commentPaging.last = paging!.last
                if self.commentPaging.next.page == self.commentPaging.last.page {
                    self.commits[indexPath.section].loadingComplete = true
                }
            } else {
                self.commits[indexPath.section].loadingComplete = true
            }
            self.commits[indexPath.section].comments.append(contentsOf: comments)
            self.didFetchComments?(comments, indexPath)
            self.isLoading = false
        }) { [weak self] error in
            self?.didFailCommentsLoad?(error)
            self?.isLoading = false
        }
    }
}
