//
//  TaskDetailViewController.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import UIKit

protocol TaskDetailViewControllerDelegate: AnyObject {
    func didUpdateTodo(_ todo: TodoModel)
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - UI-компоненты
    private let contentView = UIView()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "PrimaryText")
        label.text = "Описание отсутствует"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - VIPER
    var presenter: TaskDetailPresenterInputProtocol?
    
    // MARK: - Свойства
    var delegate: TaskDetailViewControllerDelegate?
    private var currentTask: TodoModel?
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissGesture()
        presenter?.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.didUpdateTask(descriptionTextView.text)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.primaryBackground
        
        setupNavigationBar()
        setupContentView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = AppColors.completedTaskAccent
    }

    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
    }
    
    private func setupSubviews() {
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = AppColors.secondaryText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textColor = AppColors.primaryText
        descriptionTextView.tintColor = AppColors.primaryText
        descriptionTextView.isEditable = true
        descriptionTextView.delegate = self
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(dateLabel)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(descriptionTextView)
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 26),
            placeholderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - TaskDetailViewProtocol
extension TaskDetailViewController: TaskDetailViewInputProtocol {
    
    func showTaskDetails(_ task: TodoModel) {
        currentTask = task
        
        DispatchQueue.main.async {
            self.title = task.title
            
            if let description = task.taskDescription, !description.isEmpty {
                self.descriptionTextView.text = description
                self.placeholderLabel.isHidden = true
            } else {
                self.descriptionTextView.text = nil
                self.placeholderLabel.isHidden = false
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            self.dateLabel.text = formatter.string(from: task.createdAt)
        }
    }
    
    func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITextViewDelegate
extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !(textView.text?.isEmpty ?? true)
    }
}
