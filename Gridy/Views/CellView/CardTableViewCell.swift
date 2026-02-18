//
//  CardCollectionViewCell.swift
//  Gridy
//
//  Created by Julia Morozova on 16. 2. 2026..
//

import UIKit

class CardTableViewCell: UITableViewCell {
    static let cardId = "CardTableViewCell"

    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .blackApp
        $0.numberOfLines = 1
        return $0
    }(UILabel())

    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 3
        return $0
    }(UILabel())

    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())

    private lazy var cardContainer: UIView = {
        $0.layer.cornerRadius = 18
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.08
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        return $0
    }(UIView())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with card: BoardCard) {
        titleLabel.text = card.title
        descriptionLabel.text = card.description

        switch card.status {
        case .todo:
            cardContainer.backgroundColor = .blueApp
        case .inProgress:
            cardContainer.backgroundColor = .yellowApp
        case .done:
            cardContainer.backgroundColor = .greenApp
        }
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cardContainer)
        cardContainer.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)

        createConstraints()
    }

    private func createConstraints() {
        let bottomConstraint = cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            // Отступы контейнера от краев ячейки - отступы между карточками
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bottomConstraint,

            // Отступы стека внутри контейнера
            stackView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -16)
        ])
    }

    func getDragPreviewParameters() -> UIDragPreviewParameters {
        let parameters = UIDragPreviewParameters()
        let path = UIBezierPath(roundedRect: cardContainer.frame, cornerRadius: cardContainer.layer.cornerRadius)
        parameters.visiblePath = path
        return parameters
    }
}
