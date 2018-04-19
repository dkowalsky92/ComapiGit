//
//  ReleasesTableViewCell.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit

class ReleasesTableViewCell: BaseTableViewCell {
    
    var nameLabel: UILabel
    var tagLabel: UILabel
    var authorImageView: UIImageView
    var authorNameLabel: UILabel
    var dateLabel: UILabel
    var urlButton: UIButton
    
    private let imageSize: CGFloat = 34.0
    
    var didTapUrlButton: (() -> ())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        tagLabel = UILabel()
        dateLabel = UILabel()
        urlButton = UIButton()
        authorImageView = UIImageView()
        authorNameLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
    }
    
    override func configure() {
        customize(self)
        customize(nameLabel)
        customize(tagLabel)
        customize(urlButton)
        customize(dateLabel)
        customize(authorImageView)
        customize(authorNameLabel)
        
        layout(nameLabel)
        layout(tagLabel)
        layout(urlButton)
        layout(dateLabel)
        layout(authorImageView)
        layout(authorNameLabel)
        
        constrain(nameLabel)
        constrain(tagLabel)
        constrain(urlButton)
        constrain(dateLabel)
        constrain(authorImageView)
        constrain(authorNameLabel)
    }
    
    override func customize(_ view: UIView) {
        switch view {
        case self:
            contentView.backgroundColor = Colors.cadetGray()
            selectionStyle = .none
        case nameLabel:
            nameLabel.font = UIFont.systemFont(ofSize: 14)
            nameLabel.numberOfLines = 0
            nameLabel.textColor = Colors.isabellineWhite()
        case tagLabel:
            tagLabel.font = UIFont.systemFont(ofSize: 11)
            tagLabel.numberOfLines = 0
            tagLabel.textColor = Colors.weldonBlue()
        case urlButton:
            urlButton.addTarget(self, action: #selector(tappedUrlButton), for: .touchUpInside)
            urlButton.setTitleColor(Colors.isabellineWhite(), for: UIControlState())
            urlButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            urlButton.titleEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
            urlButton.titleLabel?.numberOfLines = 0
            urlButton.layer.cornerRadius = 8.0
            urlButton.backgroundColor = Colors.weldonBlue()
            urlButton.layer.shadowColor = Colors.darkGreenBlack().cgColor
            urlButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            urlButton.layer.shadowRadius = 4.0
            urlButton.layer.shadowOpacity = 0.25
        case dateLabel:
            dateLabel.font = UIFont.systemFont(ofSize: 13)
            dateLabel.numberOfLines = 0
            dateLabel.textColor = Colors.weldonBlue()
        case authorNameLabel:
            authorNameLabel.font = UIFont.systemFont(ofSize: 14)
            authorNameLabel.numberOfLines = 0
            authorNameLabel.textColor = Colors.isabellineWhite()
        case authorImageView:
            authorImageView.clipsToBounds = true
            authorImageView.layer.cornerRadius = imageSize / 2
            authorImageView.contentMode = .scaleAspectFit
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
            case nameLabel:
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.top.equalTo(tagLabel.snp.bottom).offset(4)
            case tagLabel:
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.top.equalToSuperview().offset(4)
            case dateLabel:
                $0.top.equalTo(authorNameLabel.snp.bottom).offset(4)
                $0.leading.equalTo(authorNameLabel.snp.leading)
                $0.width.lessThanOrEqualTo(140)
            case authorNameLabel:
                $0.centerY.equalTo(authorImageView.snp.centerY)
                $0.leading.equalTo(authorImageView.snp.trailing).offset(8)
                $0.width.lessThanOrEqualTo(140)
            case authorImageView:
                $0.leading.equalToSuperview().offset(24)
                $0.top.equalTo(nameLabel.snp.bottom).offset(8)
                $0.size.equalTo(imageSize)
            case urlButton:
                $0.top.equalTo(dateLabel.snp.bottom).offset(16)
                $0.leading.equalToSuperview().offset(16)
                $0.bottom.equalToSuperview().offset(-4)
                $0.trailing.equalToSuperview().offset(-16)
            default:
                break
            }
        }
    }
    
    @objc func tappedUrlButton() {
        didTapUrlButton?()
    }
    
    func configure(withRelease release: Release, downloader: ImageDownloader) {
        if let urlString = release.author.avatarUrl, let url = URL(string: urlString) {
            downloader.download(url, success: { [weak self] image in
                self?.authorImageView.image = image
            }) { [weak self] _ in
                self?.authorImageView.image = UIImage(named: "placeholder_avatar")
            }
        } else {
            authorImageView.image = UIImage(named: "placeholder_avatar")
        }

        authorNameLabel.text = release.author.login
        urlButton.setTitle(release.htmlUrl, for: UIControlState())
        nameLabel.text = release.name
        
        if let tag = release.tagName {
            tagLabel.text = tag
        }
        if let date = release.publishedAt.toDate(),
            let formattedDate = date.stringWith(format: "yyyy-MM-dd") {
            dateLabel.text = formattedDate
        }

    }
}
