//
//  TodoListViewController.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

class TodoListViewController: UIViewController {
    
    // MARK: - UI-компоненты
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var taskCountLabel: UILabel?
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - VIPER
    var presenter: TodoListPresenterInputProtocol?
    var actionMenuService: ActionMenuPresenting?
    
    // MARK: - Data
    private var todos: [TodoModel] = []
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Задачи"
        view.backgroundColor = UIColor(named: "PrimaryBackground")
        
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupActivityIndicator()
        setupConstraints()
        setupToolbar()
    }
    
    private func setupNavigationBar() {
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        let searchBar = searchController.searchBar
        let textField = searchBar.searchTextField

        textField.backgroundColor = AppColors.secondaryBackground
        textField.textColor = AppColors.primaryText
        searchBar.tintColor = AppColors.primaryText

        textField.rightView = nil
        textField.rightViewMode = .never
        textField.clearButtonMode = .never

        let microphoneButton = UIButton(type: .system)
        microphoneButton.setImage(UIImage(systemName: "microphone.fill"), for: .normal)
        microphoneButton.tintColor = AppColors.secondaryText
        microphoneButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)

        let micContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        micContainer.addSubview(microphoneButton)
        microphoneButton.center = micContainer.center

        textField.addSubview(micContainer)

        micContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            micContainer.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            micContainer.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -8),
            micContainer.widthAnchor.constraint(equalToConstant: 36),
            micContainer.heightAnchor.constraint(equalToConstant: 36)
        ])

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    @objc private func microphoneTapped() {
        print("Microphone tapped")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = AppColors.primaryBackground
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }
    
    private func setupToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)

        let countLabel = UILabel()
        countLabel.text = ""
        countLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        countLabel.textColor = AppColors.primaryText
        let taskCountItem = UIBarButtonItem(customView: countLabel)
        self.taskCountLabel = countLabel

        let addButtonImage = UIImage(systemName: "square.and.pencil")
        let addTaskButton = UIBarButtonItem(image: addButtonImage, style: .plain, target: self, action: #selector(addTodoTapped))
        addTaskButton.tintColor = AppColors.completedTaskAccent

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [flexibleSpace, taskCountItem, flexibleSpace, addTaskButton]
        
        navigationController?.toolbar.barTintColor = AppColors.secondaryBackground
        navigationController?.toolbar.tintColor = AppColors.primaryText
        navigationController?.toolbar.isTranslucent = false
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Акшены
    @objc private func addTodoTapped() {
        presenter?.addTodo()
    }
}

// MARK: - TodoListViewProtocol
extension TodoListViewController: TodoListViewProtocol {

    func showTodos(_ todos: [TodoModel]) {
        self.todos = todos
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showUnfinishedTodos(_ amount: Int) {
        taskCountLabel?.text = "\(amount) задач"
        taskCountLabel?.sizeToFit()
    }

    func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todos[indexPath.row]
        presenter?.didSelectTodo(todo)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = todos[indexPath.row]
            presenter?.deleteTodo(todo)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UISearchResultsUpdating
extension TodoListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        presenter?.searchTodos(with: searchText)
    }
}

// MARK: - TodoTableViewCellDelegate
extension TodoListViewController: TodoTableViewCellDelegate {
    
    func didTapCheckbox(for todo: TodoModel) {
        var updatedTodo = todo
        updatedTodo = TodoModel(
            id: todo.id,
            title: todo.title,
            taskDescription: todo.taskDescription,
            createdAt: todo.createdAt,
            isCompleted: !todo.isCompleted,
            userId: todo.userId
        )
        presenter?.didUpdateTodo(updatedTodo)
    }
}

// MARK: - Жест длительного нажатия для вызова taskSpotlightView с меню опций
extension TodoListViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: tableView)

        guard let indexPath = tableView.indexPathForRow(at: point),
              let cell = tableView.cellForRow(at: indexPath) as? TodoTableViewCell else { return }

        let todo = todos[indexPath.row]
        
        // Поскольку мы находимся в стеке навигатора, чтобы заблюрить весь экран, берем view navigationControllerа
        guard let containerView = navigationController?.view else { return }
        actionMenuService?.showMenu(
            for: cell,
            with: TodoInfo(title: todo.title, taskDescription: todo.taskDescription, createdAt: todo.createdAt),
            in: containerView,
            withActions: [
                ActionMenuItem(title: "Редактировать", icon: UIImage(systemName: "square.and.pencil"), type: .edit, style: .normal),
                ActionMenuItem(title: "Поделиться", icon: UIImage(systemName: "square.and.arrow.up"), type: .share, style: .normal),
                ActionMenuItem(title: "Удалить", icon: UIImage(systemName: "trash"), type: .delete, style: .destructive),
            ]
        ) { [weak self] selected in
            guard let self = self else { return }

            switch selected {
            case .edit:
                self.presenter?.didTapEditAction(for: todo)
            case .share:
                self.presenter?.didTapShareAction(for: todo)
            case .delete:
                self.presenter?.didTapDeleteAction(for: todo)
            }
        }
    }
}
