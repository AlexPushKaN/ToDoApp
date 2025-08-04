//
//  AppColors.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

enum AppColors {

    static var completedTaskAccent: UIColor {
        return UIColor(named: "CompletedTaskAccent") ?? .systemGreen
    }

    static var customColors: UIColor {
        return UIColor(named: "CustomColors") ?? .systemTeal
    }

    static var primaryBackground: UIColor {
        return UIColor(named: "PrimaryBackground") ?? .systemBackground
    }

    static var primaryText: UIColor {
        return UIColor(named: "PrimaryText") ?? .label
    }

    static var secondaryBackground: UIColor {
        return UIColor(named: "SecondaryBackground") ?? .red
    }

    static var secondaryText: UIColor {
        return UIColor(named: "SecondaryText") ?? .secondaryLabel
    }
}
