//
//  ReposTableViewCell.swift
//  ComapiGit
//
//  Created by Dominik Kowalski on 18/04/2018.
//  Copyright © 2018 Dominik Kowalski. All rights reserved.
//

import UIKit
import SnapKit

class ReposTableViewCell: BaseTableViewCell {
    
    enum CellState {
        case compact
        case expanded
    }
    
    var mainContainer: UIView
    var actionContainer: UIStackView
    
    var nameLabel: UILabel
    var languageLabel: UILabel
    var urlButton: UIButton
    var commitsButton: ActionButton
    var releasesButton: ActionButton
    
    var didTapUrlButton: (() -> ())?
    var didTapCommitsButton: (() -> ())?
    var didTapReleasesButton: (() -> ())?
    
    private let buttonSize: CGFloat = 54
    
    private(set) var state: CellState
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        mainContainer = UIView()
        actionContainer = UIStackView()
        nameLabel = UILabel()
        languageLabel = UILabel()
        urlButton = UIButton()
        commitsButton = ActionButton(color: Colors.weldonBlue(), title: "Commits")
        releasesButton = ActionButton(color: Colors.wildBlueYonder(), title: "Releases")
        
        state = .compact
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        customize(self)
        customize(mainContainer)
        customize(actionContainer)
        customize(nameLabel)
        customize(languageLabel)
        customize(urlButton)
        customize(commitsButton)
        customize(releasesButton)
        
        layout(mainContainer)
        layout(actionContainer)
        layout(nameLabel)
        layout(languageLabel)
        layout(urlButton)
        
        constrain(mainContainer, state: .compact)
        constrain(actionContainer, state: .compact)
        constrain(nameLabel, state: .compact)
        constrain(languageLabel, state: .compact)
        constrain(urlButton, state: .compact)
        constrain(commitsButton, state: .compact)
        constrain(releasesButton, state: .compact)
    }
    
    override func customize(_ view: UIView) {
        switch view {
        case self:
            selectionStyle = .none
        case mainContainer:
            mainContainer.backgroundColor = Colors.cadetGray()
        case actionContainer:
            actionContainer.alignment = .fill
            actionContainer.axis = .horizontal
            actionContainer.distribution = .fill
            actionContainer.spacing = 4
            actionContainer.backgroundColor = .clear
        case nameLabel:
            nameLabel.font = UIFont.systemFont(ofSize: 14)
            nameLabel.numberOfLines = 0
            nameLabel.textColor = Colors.isabellineWhite()
        case languageLabel:
            languageLabel.font = UIFont.systemFont(ofSize: 11)
            languageLabel.numberOfLines = 0
            languageLabel.textColor = Colors.wildBlueYonder()
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
        case releasesButton:
            releasesButton.addTarget(self, action: #selector(tappedReleasesButton), for: .touchUpInside)
            releasesButton.layer.cornerRadius = buttonSize / 2
            releasesButton.clipsToBounds = true
            releasesButton.layer.shadowColor = Colors.darkGreenBlack().cgColor
            releasesButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            releasesButton.layer.shadowRadius = 4.0
            releasesButton.layer.shadowOpacity = 0.5
        case commitsButton:
            commitsButton.addTarget(self, action: #selector(tappedCommitsButton), for: .touchUpInside)
            commitsButton.layer.cornerRadius = buttonSize / 2
            commitsButton.clipsToBounds = true
            commitsButton.layer.shadowColor = Colors.darkGreenBlack().cgColor
            commitsButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            commitsButton.layer.shadowRadius = 4.0
            commitsButton.layer.shadowOpacity = 0.5
        default:
            break
        }
    }
    
    override func layout(_ view: UIView) {
        switch view {
        case mainContainer:
            contentView.addSubview(view)
        case actionContainer:
            contentView.addSubview(view)
            bringSubview(toFront: view)
            actionContainer.addArrangedSubview(commitsButton)
            actionContainer.addArrangedSubview(releasesButton)
        case urlButton, nameLabel, languageLabel:
            mainContainer.addSubview(view)
        default:
            break
        }
    }
    
    func constrain(_ view: UIView, state: CellState = .compact) {
        view.snp.remakeConstraints {
            switch view {
            case mainContainer:
                $0.edges.equalToSuperview()
            case actionContainer:
                if state == .compact {
                    $0.leading.equalTo(mainContainer.snp.trailing)
                } else {
                    $0.leading.equalTo(mainContainer.snp.trailing).offset(-120)
                }
                $0.centerY.equalToSuperview()
            case nameLabel:
                $0.top.equalTo(languageLabel.snp.bottom).offset(4)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            case languageLabel:
                $0.top.equalToSuperview().offset(4)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            case urlButton:
                $0.top.equalTo(nameLabel.snp.bottom).offset(8)
                $0.leading.equalToSuperview().offset(16)
                $0.bottom.equalToSuperview().offset(-8)
            case releasesButton:
                $0.size.equalTo(buttonSize)
            case commitsButton:
                $0.size.equalTo(buttonSize)
            default:
                break
            }
        }
    }
    
    @objc func tappedUrlButton() {
        didTapUrlButton?()
    }
    
    @objc func tappedCommitsButton() {
        didTapCommitsButton?()
    }
    
    @objc func tappedReleasesButton() {
        didTapReleasesButton?()
    }
    
    func switchToCompact() {
        state = .compact
        constrain(mainContainer, state: state)
        constrain(actionContainer, state: state)
        layoutIfNeeded()
    }
    
    func toggleState(animated: Bool = true) {
        state = state == .compact ? .expanded : .compact
        constrain(mainContainer, state: state)
        constrain(actionContainer, state: state)
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }
    
    func configure(withRepo repo: Repository) {
        nameLabel.text = repo.name
        languageLabel.text = repo.language
        urlButton.setTitle(repo.htmlUrl, for: UIControlState())
    }
}
