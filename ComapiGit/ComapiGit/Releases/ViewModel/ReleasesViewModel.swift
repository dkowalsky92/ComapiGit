//
//  ReleasesViewModel.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReleasesViewModel: BaseViewModel {
    
    let interactor: ReleasesInteractor
    var releases: [Release]
    var repo: Repository
    var downloader: ImageDownloader

    var paging: Paging
    var loadingComplete = false
    
    var didLoadAllResults: (() -> ())?
    
    var didFetchReleases: ((_ releases: [Release]) -> ())?
    var didFailReleasesLoad: ((Error?) -> ())?
    
    var isLoading = false
    
    init(repo: Repository) {
        interactor = ReleasesInteractor(timeout: 10.0)
        downloader = ImageDownloader()
        releases = []
        let next = Paging.Values(page: 1, perPage: 10)
        let last = Paging.Values(page: 1, perPage: 10)
        paging = Paging(next: next, last: last)
        
        self.repo = repo
        
        super.init()
    }
    
    func reset() {
        releases = []
        let next = Paging.Values(page: 1, perPage: 10)
        let last = Paging.Values(page: 1, perPage: 10)
        paging = Paging(next: next, last: last)
        loadingComplete = false
    }
    
    func fetchReleases() {
        if loadingComplete {
            didLoadAllResults?()
            return
        }
        
        isLoading = true
        interactor.fetchReleases(forRepo: repo, page: paging.next.page, perPage: paging.next.perPage, completion: { [weak self] releases, paging in
            if paging != nil {
                if self?.paging.next.page == paging!.last.page {
                    self?.loadingComplete = true
                }
                self?.paging.next = paging!.next
                self?.paging.last = paging!.last
            } else {
                self?.loadingComplete = true
            }
            self?.releases.append(contentsOf: releases)
            self?.didFetchReleases?(releases)
            self?.isLoading = false
        }) { [weak self] error in
            self?.didFailReleasesLoad?(error)
            self?.isLoading = false
        }
    }
}
