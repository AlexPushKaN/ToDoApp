//
//  AppColors.swift
//  ToDoApp
//
//  Created by Александр Муклинов on 04.08.2025.
//

import UIKit

enum AppColors {

    static var completedTaskAccent: UIColor {
        return UIColor(named: "CompletedTaskAccent") ?? #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }

    static var customColors: UIColor {
        return UIColor(named: "CustomColors") ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    static var primaryBackground: UIColor {
        return UIColor(named: "PrimaryBackground") ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    static var primaryText: UIColor {
        return UIColor(named: "PrimaryText") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    static var secondaryBackground: UIColor {
        return UIColor(named: "SecondaryBackground") ?? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }

    static var secondaryText: UIColor {
        return UIColor(named: "SecondaryText") ?? #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    static var actionMenuBackground: UIColor {
        return UIColor(named: "ActionMenuBackground") ?? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}
