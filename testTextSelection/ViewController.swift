//
//  ViewController.swift
//  testTextSelection
//
//  Created by James Tang on 29/3/2023.
//

import UIKit

class SafeTextView: UITextView {
    override var selectedTextRange: UITextRange? {
        set {
            Swift.print("TTT selectedTextRange \(newValue)")
            super.selectedTextRange = newValue
        }
        get {
            super.selectedTextRange
        }
    }
}

class ViewController: UIViewController {

    let textView: UITextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.frame = view.bounds.insetBy(dx: 50, dy: 50)
        view.addSubview(textView)
        textView.backgroundColor = .gray
    }

}

