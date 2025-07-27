import UIKit
import SDWebImage

final class MealsListViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: MealsListViewModel
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

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
        viewModel.fetchMeals()
    }

    // MARK: - Actions

    @objc private func didTapSearch() {
        if navigationItem.searchController == nil {
            setupSearchController()
        }
        searchController.isActive = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.applySearchBarStyling()
            self.applySearchCancelButtonStyling()
        }
    }

    @objc private func didTapFilter() {
        let filterVC = FiltersViewController(viewModel: viewModel.filtersViewModel)
        let nav = UINavigationController(rootViewController: filterVC)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(nav, animated: true)
    }

    func setupNavigation() {
        title = "MealKit"
        navigationItem.largeTitleDisplayMode = .never

        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItems = [filterButton, searchButton]
    }
}

// MARK: - ViewCode Setup

extension MealsListViewController: ViewCode {
    func addSubviews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setupStyle() {
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .singleLine
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseIdentifier)
    }

    func bindViewModel() {
        viewModel.onMealsFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func setupAccessibility() {
        tableView.accessibilityLabel = "Meals list"
        tableView.accessibilityIdentifier = "mealsTableView"
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
        searchController.searchBar.backgroundColor = UIColor(hex: "#7B2D26")
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
        navigationItem.searchController = nil
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MealsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.meals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MealCell.reuseIdentifier,
            for: indexPath
        ) as? MealCell else {
            return UITableViewCell()
        }

        let meal = viewModel.meals[indexPath.row]
        cell.configure(with: meal)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMeal(at: indexPath.row)
    }
}

// MARK: - Filters Delegate

extension MealsListViewController: FiltersViewModelDelegate {
    func didApplyFilters(_ filters: [String]) {
        viewModel.applyFilters(filters)
    }
}
