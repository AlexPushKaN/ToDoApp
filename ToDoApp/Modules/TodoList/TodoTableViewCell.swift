//
//  TodoTableViewCell.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func didTapCheckbox(for todo: TodoModel)
}

class TodoTableViewCell: UITableViewCell {
    
    static let identifier = "TodoTableViewCell"
    
    // MARK: - UI-компоненты
    private let checkboxButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Свойства
    weak var delegate: TodoTableViewCellDelegate?
    var todo: TodoModel?
    
    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "PrimaryBackground")
        selectionStyle = .none
        setupCheckboxButton()
        setupLabels()
        setupStackView()
        setupConstraints()
    }
    
    private func setupCheckboxButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        let circle = UIImage(systemName: "circle", withConfiguration: config)
        let checkmark = UIImage(systemName: "checkmark.circle", withConfiguration: config)
        checkboxButton.setImage(circle, for: .normal)
        checkboxButton.setImage(checkmark, for: .selected)
        checkboxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = AppColors.primaryText
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = AppColors.secondaryText
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = AppColors.secondaryText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(checkboxButton)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkboxButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 40),
            checkboxButton.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
    }
    
    // MARK: - Конфигурация ячейки
    func configure(with todo: TodoModel) {
        self.todo = todo
        
        titleLabel.text = todo.title
        descriptionLabel.text = todo.taskDescription
        descriptionLabel.isHidden = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        dateLabel.text = formatter.string(from: todo.createdAt)
        
        checkboxButton.isSelected = todo.isCompleted
        
        // Обновление стиля текста в зависимости от статуса завершения задачи
        if todo.isCompleted {
            checkboxButton.tintColor = AppColors.completedTaskAccent
            titleLabel.textColor = AppColors.secondaryText
            descriptionLabel.textColor = AppColors.secondaryText
            dateLabel.textColor = AppColors.secondaryText
            
            let attributeString = NSMutableAttributedString(string: todo.title)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
        } else {
            checkboxButton.tintColor = AppColors.secondaryText
            titleLabel.textColor = AppColors.primaryText
            descriptionLabel.textColor = AppColors.secondaryText
            dateLabel.textColor = AppColors.secondaryText
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
        }
    }
    
    // MARK: - Экшены
    @objc private func checkboxTapped() {
        guard let todo = todo else { return }
        delegate?.didTapCheckbox(for: todo)
    }
}

