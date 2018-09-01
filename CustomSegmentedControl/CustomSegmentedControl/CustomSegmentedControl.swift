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
    
    var buttons = [UIButton]()
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var commaSeparatedTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    override func draw(_ rect: CGRect) {
        //makes perfect rounded caps on each side
        layer.cornerRadius = frame.height / 2
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
    }
    
    
    
    
}
