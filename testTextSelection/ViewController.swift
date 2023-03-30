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

        textView1.delegate = self
        textView2.delegate = self

        textView1.text = """
1
😀
"""
        textView2.text = """
2
😀
"""
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        Swift.print("TTT textView \(Unmanaged.passUnretained(textView).toOpaque()) didChangeSelection \(textView.selectedTextRange)")
    }
}
