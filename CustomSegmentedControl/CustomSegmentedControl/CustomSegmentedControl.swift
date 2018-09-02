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
            updateTextColor(withMainColor: textColor, andSelectedColor: selectedTitleColor)
        }
    }
    
    @IBInspectable
    private var selectorBackgroundColor: UIColor = .white {
        didSet {
            updateSelectorColor(with: selectorBackgroundColor)
        }
    }
    
    @IBInspectable
    private var selectedTitleColor: UIColor = .gray {
        didSet {
            updateTextColor(withMainColor: textColor, andSelectedColor: selectedTitleColor)
        }
    }
    
    @IBInspectable
    private var selectedSegmentNumber: Int = 0 {
        didSet {
            cleanUpSubviews()
            updateView()
            updateTextColor(withMainColor: textColor, andSelectedColor: selectedTitleColor)
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
        buttons.forEach {
            stackView.removeArrangedSubview($0)
        }
        buttons = []
    }
    
    private func updateTextColor(withMainColor mainColor: UIColor, andSelectedColor selectedColor: UIColor) {
        buttons.forEach { button in
            button.setTitleColor(mainColor, for: .normal)
        }
        
        guard selectedSegmentNumber < buttons.count  else { return }
        buttons[selectedSegmentNumber].setTitleColor(selectedColor, for: .normal)
    }
    
    private func updateSelectorColor(with color: UIColor) {
        selectorView.backgroundColor = color
    }
    
    private func updateView() {
        
        var cleanString = commaSeparatedTitles.trimmingCharacters(in: .whitespaces)
        cleanString = cleanString.replacingOccurrences(of: " ", with: "")

        let buttonTitles = cleanString.components(separatedBy: ",")
        
        buttonTitles.forEach { title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonWasSelected(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        setUpButtonsInStackView()
    }
    
    
    private func setUpButtonsInStackView() {
        guard !buttons.isEmpty else { return }
        
        setUpSelectorView()
        
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
        
        
    }
    
    
    private func setUpSelectorView() {
        
        let segmentedControlWidth = bounds.size.width
        let buttonsCount = CGFloat(buttons.count)
        let widthOfOneButton = segmentedControlWidth / buttonsCount 
        let orderOfButton = (CGFloat(buttons.count - selectedSegmentNumber))
        
        let xPositionOfSelectedButton = segmentedControlWidth - (widthOfOneButton * orderOfButton)
        
        
        selectorView.frame = CGRect(x: xPositionOfSelectedButton, y: 0, width: widthOfOneButton, height: frame.height)
        selectorView.backgroundColor = selectorBackgroundColor
        selectorView.layer.cornerRadius = selectorView.frame.height / 2
        
        guard !buttons.isEmpty else { return }
        
        stackView.addSubview(selectorView)
    }
    
    
    @objc private func buttonWasSelected(sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.selectorView.frame = sender.frame
            
            sender.setTitleColor(self.selectedTitleColor, for: .normal)
            
            self.buttons.forEach { button in
                if button != sender {
                    button.setTitleColor(self.textColor, for: .normal)
                }
            }
        })
    }
    
}
