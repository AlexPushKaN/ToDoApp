//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func didAddTodo(_ todo: TodoModel)
}

class AddTaskViewController: UIViewController {
    
    // MARK: - UI-компоненты
    private let contentView = UIView()
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - VIPER
    var presenter: AddTaskPresenterInputProtocol?
    
    // MARK: - Свойства
    var delegate: AddTaskViewControllerDelegate?
    private var currentTask: TodoModel?
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupСontentView()
        setupSubviews()
        setupConstraints()
        setupKeyboardDismissGesture()
    }
    
    private func setupNavigationBar() {
        title = "Новая задача"
        
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        let saveButton = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        navigationController?.navigationBar.tintColor = AppColors.completedTaskAccent
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupСontentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
    }
    
    private func setupSubviews() {
        titleLabel.text = "Название"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.backgroundColor = AppColors.primaryBackground
        titleTextField.tintColor = AppColors.primaryText
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Введите название задачи"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = "Описание"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.backgroundColor = AppColors.primaryBackground
        descriptionTextView.tintColor = AppColors.primaryText
        descriptionTextView.layer.borderColor = AppColors.secondaryBackground.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(descriptionLabel)
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
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            descriptionTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        presenter?.cancelTask()
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showErrorMessage("Пожалуйста, введите название задачи")
            return
        }
        
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDescription = description.isEmpty ? nil : description
        
        presenter?.saveTask(title: title.trimmingCharacters(in: .whitespacesAndNewlines), description: finalDescription)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AddTaskViewProtocol
extension AddTaskViewController: AddTaskViewInputProtocol {
    
    func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}
