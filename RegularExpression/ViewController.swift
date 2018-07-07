//
//  ViewController.swift
//  RegularExpression
//
//  Created by Akasaaa on 2018/07/06.
//  Copyright © 2018年 Akasaaa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var regularExpression: NSTextView!
    @IBOutlet var text: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        regularExpression.delegate = self
        text.delegate = self
        patternMatch()
    }
    
    private func patternMatch() {
        guard !regularExpression.string.isEmpty else {
            regularExpression.setColor(.black, position: .all)
            text.setColor(.black, position: .all)
            return
        }
        
        guard let matches = try? text.string.matches(pattern: regularExpression.string) else {
            regularExpression.setColor(.red, position: .all)
            text.setColor(.black, position: .all)
            return
        }
        
        regularExpression.setColor(.black, position: .all)
        text.setColor(.black, position: .all)
        
        matches.forEach {
            text.setColor(.red, position: .range($0))
        }
    }
}

extension ViewController: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        patternMatch()
    }
}

extension String {
    func matches(pattern: String) throws -> [NSRange] {
        let re = try NSRegularExpression(pattern: pattern)
        let matches = re.matches(in: self, range: NSMakeRange(0, count))
        return matches.map { $0.range }
    }
}

extension NSTextView {
    enum TextPosition {
        case all
        case range(NSRange)
    }
    
    func setColor(_ color: NSColor, position: TextPosition) {
        let range: NSRange
        switch position {
        case .all:
            range = NSMakeRange(0, string.count)
        case .range(let value):
            range = value
        }
        textStorage?.setAttributes([.foregroundColor: color,
                                    .font: NSFont.systemFont(ofSize: 16)],
                                   range: range)
    }
}
