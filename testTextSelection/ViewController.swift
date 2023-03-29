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
    @IBOutlet var textView1: UITextView!
    @IBOutlet var textView2: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        layoutManager.addTextContainer(textContainer)
//        textView1 = UITextView(frame: .zero, textContainer: nil)
//        let textKit1 = textView1.layoutManager != nil // force textKit1
//        textView2 = UITextView(frame: .zero, textContainer: nil) // textKit 2
//
//        textView1.frame = CGRect(x: 50, y: 50, width: 300, height: 300)
//        textView2.frame = CGRect(x: 400, y: 50, width: 300, height: 300)
//        view.addSubview(textView1)
//        view.addSubview(textView2)
//        textView1.backgroundColor = .lightGray
//        textView2.backgroundColor = .green
//
//        textView1.text = "Using textKit 1: \(textKit1)"
//        textView2.text = "Using textKit 2"
    }

}

