//
//  ActionButton.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 05.08.2025.
//

import UIKit

final class ActionButton: UIButton {
    
    var actionType: ActionMenuItemType?

    init(menuItem: ActionMenuItem, target: Any?, action: Selector) {
        super.init(frame: .zero)
        
        self.actionType = menuItem.type
        configure(with: menuItem)
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with item: ActionMenuItem) {
        var config = UIButton.Configuration.plain()
        config.title = item.title
        config.image = item.icon
        config.imagePlacement = .trailing
        config.imagePadding = 0
        config.baseForegroundColor = item.style == .destructive ? .systemRed : .systemBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.titleAlignment = .leading

        configuration = config
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        contentHorizontalAlignment = .fill
    }
}
