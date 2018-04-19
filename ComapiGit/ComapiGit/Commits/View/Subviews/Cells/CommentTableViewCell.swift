//
//  CommentTableViewCell.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 19/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class CommentTableViewCell: BaseTableViewCell {

    var dateLabel: UILabel
    var authorImageView: UIImageView
    var authorNameLabel: UILabel
    var bodyLabel: UILabel
    
    let imageSize: CGFloat = 34.0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        dateLabel = UILabel()
        authorImageView = UIImageView()
        authorNameLabel = UILabel()
        bodyLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        customize(self)
        customize(dateLabel)
        customize(authorImageView)
        customize(authorNameLabel)
        customize(bodyLabel)

        layout(dateLabel)
        layout(authorImageView)
        layout(authorNameLabel)
        layout(bodyLabel)

        constrain(dateLabel)
        constrain(authorImageView)
        constrain(authorNameLabel)
        constrain(bodyLabel)
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
        case bodyLabel:
            bodyLabel.font = UIFont.systemFont(ofSize: 12)
            bodyLabel.numberOfLines = 0
            bodyLabel.textColor = Colors.isabellineWhite()
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
                $0.leading.equalToSuperview().offset(32)
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
            case bodyLabel:
                $0.top.equalTo(dateLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().offset(32)
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalToSuperview().offset(-8)
            default:
                break
            }
        }
    }

    func configure(withComment comment: Comment, downloader: ImageDownloader) {
        if let urlString = comment.author.avatarUrl, let url = URL(string: urlString) {
            downloader.download(url, success: { [weak self] image in
                self?.authorImageView.image = image
            }) { [weak self] _ in
                self?.authorImageView.image = UIImage(named: "placeholder_avatar")
            }
        } else {
            authorImageView.image = UIImage(named: "placeholder_avatar")
        }
        if let date = comment.createdAt.toDate(),
            let formattedDate = date.stringWith(format: "yyyy-MM-dd") {
            dateLabel.text = formattedDate
        }
        bodyLabel.text = comment.body
        authorNameLabel.text = comment.author.login
    }
}
