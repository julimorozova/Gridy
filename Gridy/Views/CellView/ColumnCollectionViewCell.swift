//
//  ColumnCollectionViewCell.swift
//  Gridy
//
//  Created by Julia Morozova on 16. 2. 2026..
//

import UIKit

protocol ColumnCellDelegate: AnyObject {
    func didSelectCard(_ card: BoardCard)
}

class ColumnCollectionViewCell: UICollectionViewCell {
    static let cellId = "ColumnCollectionViewCell"
    weak var delegate: ColumnCellDelegate?

    private var cards: [BoardCard] = []
    private var currentStatus: CardStatus = .todo


    private lazy var titleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .blackApp
        return $0
    }(UILabel())

    private lazy var tableView: UITableView = {
        $0.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.cardId)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.dragInteractionEnabled = true
        $0.dragDelegate = self
        $0.dropDelegate = self
        $0.dataSource = self
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(status: CardStatus) {
        self.currentStatus = status
        titleLabel.text = status.rawValue
        self.cards = MockDataManager.shared.getCards(for: status)
        tableView.reloadData()
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(tableView)

        createConstraints()
    }

    private func createConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }


}

extension ColumnCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.cardId, for: indexPath) as? CardTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cards[indexPath.row])
        return cell
    }
    

}

extension ColumnCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let card = self.cards[indexPath.row]

        let itemProvider = NSItemProvider(object: card.id.uuidString as NSString)

        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = card

        return [dragItem]
    }
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = tableView.cellForRow(at: indexPath) as? CardTableViewCell else { return nil }
        return cell.getDragPreviewParameters()
    }

}

extension ColumnCollectionViewCell: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
        guard let item = coordinator.items.first, let card = item.dragItem.localObject as? BoardCard else { return }

        MockDataManager.shared.updateCardStatus(id: card.id, newStatus: self.currentStatus)

        NotificationCenter.default.post(name: NSNotification.Name("BoardDataUpdated"), object: nil)
    }

    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
}

extension ColumnCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCard = cards[indexPath.row]
        delegate?.didSelectCard(selectedCard)
    }
}
