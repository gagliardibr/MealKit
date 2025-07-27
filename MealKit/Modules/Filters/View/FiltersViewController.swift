//
//  FiltersViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import UIKit

final class FiltersViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: FiltersViewModel
    private let collectionView: UICollectionView

    // MARK: - Init

    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(40))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            section.interGroupSpacing = 10
            section.orthogonalScrollingBehavior = .none

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]

            return section
        }
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFilters()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Filter"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(didTapApply)
        )

        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.tintColor = .label

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        collectionView.register(
            FilterHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FilterHeaderView.reuseIdentifier
        )

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadFilters() {
        viewModel.fetchFilters { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: - Actions

    @objc private func didTapCancel() {
        dismiss(animated: true)
    }

    @objc private func didTapApply() {
        viewModel.applySelectedFilters()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension FiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FilterCell.reuseIdentifier,
            for: indexPath
        ) as? FilterCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.item(at: indexPath)
        let section = FiltersViewModel.FilterSection(rawValue: indexPath.section)!
        let isSelected = viewModel.isSelected(in: section, item: item)
        
        cell.configure(with: item, selected: isSelected)

        // FORÇA seleção visual
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return FiltersViewModel.FilterSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = FiltersViewModel.FilterSection(rawValue: section) else { return 0 }
        return viewModel.numberOfItems(in: section)
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

        if let section = FiltersViewModel.FilterSection(rawValue: indexPath.section) {
            header.title = section.title
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate
extension FiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = FiltersViewModel.FilterSection(rawValue: indexPath.section)!
        let item = viewModel.item(at: indexPath)
        viewModel.toggleSelection(in: section, item: item)
        collectionView.reloadData() // Força a atualização de TODAS as células
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.clearFilters()
    }
}
