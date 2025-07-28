//
//  FiltersViewController.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 26/07/25.
//

import UIKit

final class FiltersViewController: UIViewController {
    private let viewModel: FiltersViewModel
    private var collectionView: UICollectionView!
    private var adapter: FilterCollectionAdapter?

    // MARK: - Init
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        bindViewModel()
        fetchData()
    }

    // MARK: - Setup
    private func setupView() {
        title = "Filters"
        view.backgroundColor = .systemBackground

        let applyButton = UIBarButtonItem(title: "Apply", style: .done, target: self, action: #selector(applyFilters))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelFilters))
        navigationItem.rightBarButtonItem = applyButton
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 44)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 6
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        collectionView.register(
            FilterHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FilterHeaderView.reuseIdentifier
        )
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onFiltersUpdated = { [weak self] (sections: [FilterSection]) in
            self?.adapter?.updateSections(sections)
            self?.collectionView.reloadData()
        }
    }

    // MARK: - Data Fetch
    private func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }

            self.viewModel.fetchFilters()

            self.adapter = FilterCollectionAdapter(
                sections: viewModel.sections,
                collectionView: self.collectionView,
                toggleSelection: { [weak self] section, index in
                    self?.viewModel.toggleFilterSelection(section: section, index: index)
                }
            )


            self.collectionView.delegate = self.adapter
            self.collectionView.dataSource = self.adapter
            self.collectionView.reloadData()
        }
    }


    // MARK: - Actions
    @objc private func applyFilters() {
        viewModel.applySelectedFilters()
        dismiss(animated: true)
    }

    @objc private func cancelFilters() {
        dismiss(animated: true)
    }
}
