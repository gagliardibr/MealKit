//
//  FilterCollectionAdapter.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 27/07/25.
//

import UIKit

final class FilterCollectionAdapter: NSObject {
    private var sections: [FilterSection]
    private weak var collectionView: UICollectionView?
    private let toggleSelection: (_ section: Int, _ index: Int) -> Void

    init(
        sections: [FilterSection],
        collectionView: UICollectionView,
        toggleSelection: @escaping (_ section: Int, _ index: Int) -> Void
    ) {
        self.sections = sections
        self.collectionView = collectionView
        self.toggleSelection = toggleSelection

        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func updateSections(_ newSections: [FilterSection]) {
        self.sections = newSections
        collectionView?.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension FilterCollectionAdapter: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCell.reuseIdentifier,
            for: indexPath
        ) as? FilterCell else {
            return UICollectionViewCell()
        }

        let item = sections[indexPath.section].items[indexPath.item]
        cell.configure(title: item.name, isSelected: item.isSelected)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FilterHeaderView.reuseIdentifier,
                for: indexPath
              ) as? FilterHeaderView else {
            return UICollectionReusableView()
        }

        let section = sections[indexPath.section]
        header.configure(title: section.title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension FilterCollectionAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleSelection(indexPath.section, indexPath.item)
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
