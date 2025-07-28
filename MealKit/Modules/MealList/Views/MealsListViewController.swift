//
//  MealsListCoordinator.swift
//  MealKit
//
//  Created by Bruna Gagliardi on 22/07/25.
//

import UIKit
import Combine

final class MealsListViewController: UIViewController {
    // MARK: - Properties
    
    internal let viewModel: MealsListViewModel
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Init
    
    init(viewModel: MealsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchMeals()
    }
    
    // MARK: - Actions
    
    @objc private func didTapFilter() {
        viewModel.didTapFilter()
    }
    
    @objc private func didTapSearch() {
        navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
            searchController.searchBar.delegate = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false

            searchController.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.applySearchBarStyling()
                    self.applySearchCancelButtonStyling()
                }
    }
    
    private func handleViewState(_ state: MealsListViewModel.ViewState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            tableView.isHidden = true
        case .success, .empty:
            loadingIndicator.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
        case .error(let message):
            loadingIndicator.stopAnimating()
            tableView.isHidden = true
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MealsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.cellViewModels[indexPath.row]
        cell.accessibilityIdentifier = "mealCell_\(model.title)"
        cell.configure(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MealsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectMeal(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBar Configuration

private extension MealsListViewController {
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func applySearchBarStyling() {
        let textField = searchController.searchBar.searchTextField
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textField.textColor = .white
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search recipes...",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        
        (textField.leftView as? UIImageView)?.tintColor = .white
        
        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = .white
        }
        
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barTintColor = .clear
        searchController.searchBar.backgroundColor = DesignSystem.Colors.primaryColor
    }
    
    func applySearchCancelButtonStyling() {
        guard let cancelButton = searchController.searchBar.value(forKey: "cancelButton") as? UIButton else { return }
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.tintColor = .white
    }
}


// MARK: - UISearchBarDelegate

extension MealsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchMeals()
        } else {
            guard searchText.count > 1 else { return }
            viewModel.fetchMealsDebounced(for: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchMeals()
        DispatchQueue.main.async {
            self.navigationItem.searchController = nil
        }
    }
}
// MARK: - ViewCode Implementation

extension MealsListViewController: ViewCode {
    func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .white
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bindViewModel() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.handleViewState(state)
            }
            .store(in: &cancellables)
    }
    
    func setupAccessibility() {
        tableView.accessibilityIdentifier = "MealsTableView"
        searchController.searchBar.accessibilityIdentifier = "SearchBar"
    }
    
    func setupNavigation() {
        navigationController?.applyDefaultAppearance()
        title = "Meals"
        title = "MealKit"
        navigationItem.largeTitleDisplayMode = .never
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        searchButton.accessibilityIdentifier = "searchButton"
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(didTapFilter))
        filterButton.accessibilityIdentifier = "filterButton"
        navigationItem.rightBarButtonItems = [filterButton, searchButton]
        definesPresentationContext = true
    }
}
