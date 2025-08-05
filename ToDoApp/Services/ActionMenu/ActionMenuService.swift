//
//  ActionMenuService.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import UIKit

enum ActionMenuItemType {
    case edit
    case share
    case delete
}

enum ActionMenuItemStyle {
    case normal
    case destructive
}

struct TodoInfo {
    let title: String
    let taskDescription: String?
    let createdAt: Date
}

struct ActionMenuItem {
    let title: String
    let icon: UIImage?
    let type: ActionMenuItemType
    let style: ActionMenuItemStyle
}

// MARK: - ActionMenuPresenting
protocol ActionMenuPresenting: AnyObject {
    func showMenu(for view: UIView,
                  with todo: TodoInfo,
                  in containerView: UIView,
                  withActions actions: [ActionMenuItem],
                  onAction: @escaping (ActionMenuItemType) -> Void)

    func dismissMenu()
}

final class ActionButton: UIButton {
    var actionType: ActionMenuItemType?
}

final class ActionMenuService: ActionMenuPresenting {

    private var blurView: UIVisualEffectView?
    private var taskSpotlightView: UIView?
    private var menuView: UIView?
    private var actionHandler: ((ActionMenuItemType) -> Void)?

    func showMenu(for view: UIView,
                  with todo: TodoInfo,
                  in containerView: UIView,
                  withActions actions: [ActionMenuItem],
                  onAction: @escaping (ActionMenuItemType) -> Void) {

        self.actionHandler = onAction

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blur.frame = containerView.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.alpha = 0.0
        containerView.addSubview(blur)
        self.blurView = blur

        UIView.animate(withDuration: 0.2) {
            blur.alpha = 1.0
        }
        
        // Создаем задачу "В центре внимания"
        let taskSpotlightView = createTaskSpotlightView(
            with: containerView.convert(view.frame, from: view.superview),
            info: todo
        )
        self.taskSpotlightView = taskSpotlightView
        containerView.addSubview(taskSpotlightView)
        
        // Создаем контекстное меню под эту задачу
        let menu = createMenuView(with: actions)
        containerView.addSubview(menu)
        menu.translatesAutoresizingMaskIntoConstraints = false
        self.menuView = menu

        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: taskSpotlightView.bottomAnchor, constant: 24),
            menu.centerXAnchor.constraint(equalTo: taskSpotlightView.centerXAnchor),
            menu.widthAnchor.constraint(equalToConstant: 240)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        blur.addGestureRecognizer(tap)
        
        // Небольшая анимация для улучшения пользовательского опыта
        taskSpotlightView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut],
            animations: {
                taskSpotlightView.transform = .identity
            },
            completion: nil
        )
    }

    func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView?.alpha = 0.0
            self.menuView?.alpha = 0.0
            self.taskSpotlightView?.alpha = 0.0
        }, completion: { _ in
            self.blurView?.removeFromSuperview()
            self.menuView?.removeFromSuperview()
            self.taskSpotlightView?.removeFromSuperview()
        })
    }

    @objc private func didTapOutside() {
        dismissMenu()
    }

    private func createMenuView(with actions: [ActionMenuItem]) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 0
        container.alignment = .fill
        container.distribution = .fill
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        container.backgroundColor = AppColors.actionMenuBackground

        for (index, item) in actions.enumerated() {
            let button = ActionButton(type: .system)
            button.actionType = item.type

            var config = UIButton.Configuration.plain()
            config.title = item.title
            config.image = item.icon
            config.imagePlacement = .trailing
            config.imagePadding = 0
            config.baseForegroundColor = item.style == .destructive ? .systemRed : .systemBackground
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
            config.titleAlignment = .leading

            button.configuration = config
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.contentHorizontalAlignment = .fill
            button.addTarget(self, action: #selector(menuActionTapped(_:)), for: .touchUpInside)

            container.addArrangedSubview(button)

            if index < actions.count - 1 {
                let separator = UIView()
                separator.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.5)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                container.addArrangedSubview(separator)
            }
        }

        return container
    }
    
    private func createTaskSpotlightView(with frame: CGRect, info: TodoInfo) -> UIView {
        let inset: CGFloat = 16
        let adjustedFrame = CGRect(
            x: frame.origin.x + inset,
            y: frame.origin.y,
            width: frame.width - inset * 2,
            height: 125
        )

        let container = UIView(frame: adjustedFrame)
        container.backgroundColor = AppColors.secondaryBackground
        container.layer.cornerRadius = 12
        container.clipsToBounds = true

        let titleLabel = makeLabel(text: info.title, font: .boldSystemFont(ofSize: 17), color: AppColors.primaryText)
        let descriptionLabel = makeLabel(text: info.taskDescription ?? "", font: .systemFont(ofSize: 15), color: AppColors.primaryText)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        let dateLabel = makeLabel(text: formatter.string(from: info.createdAt), font: .systemFont(ofSize: 13), color: .gray)

        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    private func makeLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    @objc private func menuActionTapped(_ sender: ActionButton) {
        dismissMenu()
        guard let item = sender.actionType else { return }
        actionHandler?(item)
    }
}
