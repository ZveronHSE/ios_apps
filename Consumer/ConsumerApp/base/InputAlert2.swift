//
//  InputAlert.swift
//
//
//  Created by alexander on 09.02.2023.
//

import Foundation
import UIKit

/// UI элемент, предназначенный для оповещения пользователя о событиях
/// произошедших при вводе информации в соовтетствующие элементы управления
///
/// Умеет работать в двух режимах:
/// Ошибка - Уведомление красного цвета
/// Предупреждение - Уведомление оранжевого цвета
public class InputAlert2: UIView {

    public enum AlertMode {
        case warning
        case error
    }

    /// Установка времени(в секундах) на анимацию исчезновения/появления View
    public var alphaDuration = 0.3

    // MARK: UI-elements
    private var textLabel: UILabel = {
        let label = UILabel()
       // TODO: label.font = Font.robotoReqular13
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "error_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: Configure view
    private var isConfigured = false
    public func configure () {
        guard isConfigured == false else { return }
        isConfigured.toggle()

        backgroundColor = .clear
        alpha = 0.0

        addSubview(icon)
        addSubview(textLabel)

        icon.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.heightAnchor.constraint(equalTo: textLabel.heightAnchor).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true

        textLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 4).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    // MARK: action-methods
    public func show(message: String, mode: AlertMode) {
        textLabel.text = message

        let color: UIColor
        switch mode {
        case .warning: color = .orange
        case .error: color = .red
        }

        textLabel.textColor = color
        icon.image = icon.image?.withTintColor(color)

        UIView.animate(withDuration: alphaDuration) { self.alpha = 1.0 }
    }

    public func hide() {
        UIView.animate(withDuration: alphaDuration) { self.alpha = 0.0 }
    }
}
