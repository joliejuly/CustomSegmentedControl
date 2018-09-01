//
//  CustomSegmentedControl.swift
//  CustomSegmentedControl
//
//  Created by Julia Nikitina on 01/09/2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomSegmentedControl: UIView {
    
    private var buttons = [UIButton]()
    private let stackView = UIStackView()
    private let selectorView = UIView()
    
    override func awakeFromNib() {
        clipsToBounds = true
        isOpaque = false //will be black
    }
    
    
    @IBInspectable
    private var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    private var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    private var textColor: UIColor = .gray {
        didSet {
            updateTextColor(with: textColor)
        }
    }
    
    @IBInspectable
    private var selectorBackgroundColor: UIColor = .white {
        didSet {
            updateSelectorColor(with: selectorBackgroundColor)
        }
    }
    
    @IBInspectable
    private var commaSeparatedTitles: String = "" {
        didSet {
            cleanUpSubviews()
            updateView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //makes perfect rounded caps on each side
        layer.cornerRadius = frame.height / 2
    }

    private func cleanUpSubviews() {
        buttons.removeAll()
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    private func updateTextColor(with color: UIColor) {
        buttons.forEach { button in
            button.setTitleColor(color, for: .normal)
        }
    }
    
    private func updateSelectorColor(with color: selectorBackgroundColor) {
        selectorView.backgroundColor = color
    }
    
    private func updateView() {
        
        var cleanString = commaSeparatedTitles.trimmingCharacters(in: .whitespaces)
        cleanString = cleanString.replacingOccurrences(of: " ", with: "")

        let buttonTitles = cleanString.components(separatedBy: ",")
        
        buttonTitles.forEach { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            buttons.append(button)
        }
        
        setUpButtonsInStackView()
    }
    
    
    private func setUpButtonsInStackView() {
        guard !buttons.isEmpty else { return }
        
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
        }
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        setUpSelectorView()
    }
    
    
    private func setUpSelectorView() {
        guard !stackView.arrangedSubviews.isEmpty, !buttons.isEmpty else { return }
        
        stackView.addSubview(selectorView)
        
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            selectorView.widthAnchor.constraint(equalToConstant: stackView.arrangedSubviews[0].bounds.size.width),
            selectorView.heightAnchor.constraint(equalToConstant: stackView.bounds.size.height),
            selectorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            selectorView.topAnchor.constraint(equalTo: stackView.topAnchor)
        ]
    
        NSLayoutConstraint.activate(constraints)
        
        selectorView.layer.cornerRadius = selectorView.frame.height / 2
        
        buttons[0].setTitleColor(.white, for: .normal)
    }
    
    
}
