//
//  CommitTableViewCell.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 19/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommitTableViewCell: BaseTableViewCell {
    
    var dateLabel: UILabel
    var authorImageView: UIImageView
    var authorNameLabel: UILabel
    var commentImageView: UIImageView
    var activityIndicator: UIActivityIndicatorView

    
    let imageSize: CGFloat = 34.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dateLabel = UILabel()
        authorImageView = UIImageView()
        authorNameLabel = UILabel()
        commentImageView = UIImageView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
        authorNameLabel.text = ""
        authorImageView.image = nil
    }
    
    override func configure() {
        customize(self)
        customize(dateLabel)
        customize(authorImageView)
        customize(authorNameLabel)
        customize(commentImageView)
        customize(activityIndicator)

        
        layout(dateLabel)
        layout(authorImageView)
        layout(authorNameLabel)
        layout(commentImageView)
        layout(activityIndicator)

        
        constrain(dateLabel)
        constrain(authorImageView)
        constrain(authorNameLabel)
        constrain(commentImageView)
        constrain(activityIndicator)

        
    }
    
    override func customize(_ view: UIView) {
        switch view {
        case self:
            contentView.backgroundColor = Colors.cadetGray()
            selectionStyle = .none
        case dateLabel:
            dateLabel.font = UIFont.systemFont(ofSize: 13)
            dateLabel.numberOfLines = 0
            dateLabel.textColor = Colors.weldonBlue()
        case authorNameLabel:
            authorNameLabel.font = UIFont.systemFont(ofSize: 16)
            authorNameLabel.numberOfLines = 0
            authorNameLabel.textColor = Colors.isabellineWhite()
        case authorImageView:
            authorImageView.clipsToBounds = true
            authorImageView.layer.cornerRadius = imageSize / 2
            authorImageView.contentMode = .scaleAspectFit
        case commentImageView:
            commentImageView.contentMode = .scaleAspectFit
            commentImageView.image = UIImage(named: "arrow_down")!.withRenderingMode(.alwaysTemplate)
            commentImageView.tintColor = Colors.isabellineWhite()
        case activityIndicator:
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = Colors.isabellineWhite()
            activityIndicator.stopAnimating()
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
        view.snp.remakeConstraints {
            switch view {
            case authorImageView:
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(8)
                $0.size.equalTo(imageSize)
            case authorNameLabel:
                $0.top.equalTo(authorImageView.snp.top)
                $0.leading.equalTo(authorImageView.snp.trailing).offset(8)
                $0.trailing.equalToSuperview().offset(-16)
            case dateLabel:
                $0.top.equalTo(authorNameLabel.snp.bottom).offset(8)
                $0.leading.equalTo(authorNameLabel.snp.leading)
                $0.trailing.equalToSuperview().offset(-16)
            case commentImageView:
                $0.top.equalTo(activityIndicator.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(24)
                $0.bottom.equalToSuperview().offset(-4)
            case activityIndicator:
                $0.top.equalTo(dateLabel.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
            default:
                break
            }
        }
    }
    
    func startLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
    }
    
    func configure(withCommit commit: Commit, downloader: ImageDownloader) {
        if let urlString = commit.committer?.avatarUrl, let url = URL(string: urlString) {
            downloader.download(url, success: { [weak self] image in
                self?.authorImageView.image = image
            }) { [weak self] _ in
                self?.authorImageView.image = UIImage(named: "placeholder_avatar")
            }
        } else {
            authorImageView.image = UIImage(named: "placeholder_avatar")
        }
        if let date = commit.commitData.committer.date.toDate(),
            let formattedDate = date.stringWith(format: "yyyy-MM-dd") {
            dateLabel.text = formattedDate
        }
        if let name = commit.committer?.login {
            authorNameLabel.text = name
        } else {
            authorNameLabel.text = commit.commitData.committer.name
        }
    }
}
