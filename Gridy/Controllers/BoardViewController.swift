//
//  BoardViewController.swift
//  Gridy
//
//  Created by Julia Morozova on 16. 2. 2026..
//

import UIKit

/// BoardViewController скроллится горизонтально, его ячейки это колонки по статусам
/// ColumnCollectionViewCell скролится вертикально, находится внутри колонки , состоит из таблицы, одна ячейка таблица содержит карточку

class BoardViewController: UIViewController {

    private var isZoomedOut: Bool = false

    private lazy var collection: UICollectionView = {
        $0.register(ColumnCollectionViewCell.self, forCellWithReuseIdentifier: ColumnCollectionViewCell.cellId)
        $0.dataSource = self
        $0.backgroundColor = .whiteApp
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        $0.addGestureRecognizer(pinch)
        return $0
    }(UICollectionView(frame: view.frame, collectionViewLayout: createLayout()))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .whiteApp

        view.addSubview(collection)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshBoard), name: NSNotification.Name("BoardDataUpdated"), object: nil)

    }

    @objc func refreshBoard() {
        collection.reloadData() 
    }

    @objc private func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard sender.state == .ended else { return }

        if sender.scale < 1.0 {
            setZoom(out: true)
        } else {
            setZoom(out: false)
        }
    }

    private func setZoom(out: Bool) {
        guard isZoomedOut != out else { return }
        isZoomedOut = out

        collection.setCollectionViewLayout(createLayout(), animated: true)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        config.contentInsetsReference = .none
        return UICollectionViewCompositionalLayout (sectionProvider: { [weak self] _ , _ -> NSCollectionLayoutSection? in

            guard let self = self else { return nil }

            let widthDimension: NSCollectionLayoutDimension = self.isZoomedOut ? .fractionalWidth(1.0 / 3.0) : .fractionalWidth(0.85)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //отступы между колонками
            item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: widthDimension,
                heightDimension: .fractionalHeight(1.0) 
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(12)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.orthogonalScrollingBehavior = .none

            section.contentInsets = .init(top: 50, leading: 8, bottom: 20, trailing: 20)


            return section

        }, configuration: config)
    }

}

extension BoardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CardStatus.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColumnCollectionViewCell.cellId, for: indexPath) as? ColumnCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        let status = CardStatus.allCases[indexPath.item]

        cell.configure(status: status)
        return cell
    }
}

extension BoardViewController: ColumnCellDelegate {
    func didSelectCard(_ card: BoardCard) {
        let detailVC = CardDetailViewController()
        detailVC.card = card

        //present(UINavigationController(rootViewController: detailVC), animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
