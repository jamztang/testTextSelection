//
//  ViewController.swift
//  testTextSelection
//
//  Created by James Tang on 29/3/2023.
//

import UIKit

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
        textView1.text = """
TextKit 1

Heading
Paragraph
😀 Point Plain
•    Point Plain
"""
        textView2.text = """
TextKit 2

Heading
Paragraph
😀 Point Plain
•    Point Plain
"""
    }
}

