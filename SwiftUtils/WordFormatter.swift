//
//  WordMatches.swift
//  SwiftUtils
//
//  Created by Mark Bailey on 09/01/2017.
//  Copyright © 2017 MPD Bailey Technology. All rights reserved.
//

import Foundation

public protocol IWordFormatter {
    var isAttributed : Bool {get}
    func formatAttributed(_ word: String) -> NSAttributedString
    func format(_ word: String) -> String
}

public class NoFormatting : IWordFormatter {
    public var isAttributed: Bool { get { return false}}

    public func format(_ word: String) -> String { return word }
    
    public func formatAttributed(_ word: String) -> NSAttributedString {
        return NSAttributedString(string: word)
    }
}

public class SubAnagramFormatter : IWordFormatter {
    fileprivate let query : String

    public init(_ query: String){ self.query = query }
    
    public func format(_ word: String) -> String {
        if (word.length < query.length){
            let unusedLetters = query.subtractLetters(word)
            if (unusedLetters.length > 0){
                return word + " (" + unusedLetters + ")"
            }
        }
        return word
    }
    
    public func formatAttributed(_ word: String) -> NSAttributedString {
        return NSAttributedString(string: format(word))
    }
    
    public var isAttributed: Bool { get { return false}}
}

public class BlankFormatter : IWordFormatter {
    fileprivate let originalWord : String
    fileprivate let missingLetters : MissingLetters
    fileprivate let highlightAttribute : [NSAttributedStringKey : UIColor]
    
    public init(_ query: String, color : UIColor){
        self.originalWord = query.replace(WordSearch.BLANK_STR, withString: "")
        self.missingLetters = MissingLetters(letters: self.originalWord)
        self.highlightAttribute = [NSAttributedStringKey.foregroundColor : color]
    }
    
    public func format(_ word: String) -> String {
        let unusedLetters = originalWord.subtractLetters(word)
        if unusedLetters.isEmpty {
            return word
        }
        return word + " (" + unusedLetters + ")"
    }
    
    public func formatAttributed(_ word: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: format(word))
        
        var len = missingLetters.findPositions(word: word)
        while len>0
        {
            len = len - 1
            let pos = missingLetters.getPositionAt(index: len)
            mutableString.addAttributes(highlightAttribute, range: NSRange(location: pos, length: 1))
        }
        return mutableString
    }
    
    public var isAttributed: Bool { get { return true}}
}

public class SupergramFormatter : IWordFormatter {
    fileprivate let missingLetters : MissingLetters
    fileprivate let highlightAttribute : [NSAttributedStringKey : UIColor]

    public init(_ query: String, color : UIColor){
        let originalWord = query.replace(WordSearch.SUPERGRAM_STR, withString: "")
        self.missingLetters = MissingLetters(letters: originalWord)
        self.highlightAttribute = [NSAttributedStringKey.foregroundColor : color]
    }

    public var isAttributed: Bool { get { return true}}
    
    public func format(_ word: String) -> String { return word }
    
    public func formatAttributed(_ word: String) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: format(word))
        
        var len = missingLetters.findPositions(word: word)
        while len>0
        {
            len = len - 1
            let pos = missingLetters.getPositionAt(index: len)
            mutableString.addAttributes(highlightAttribute, range: NSRange(location: pos, length: 1))
        }
        return mutableString
    }
}

/// Formats a word based on the query and search type
public class WordFormatter : IWordFormatter
{
    fileprivate let defaultFormatter : IWordFormatter = NoFormatting()
    fileprivate var formatter : IWordFormatter
    public var highlightColor = UIColor.red
    
    public init(){
        formatter = defaultFormatter
    }
    
    //
    // IWordFormatter methods (State pattern)
    //
    public func format(_ word: String) -> String { return formatter.format(word) }
    
    public func formatAttributed(_ word: String) -> NSAttributedString {
        return formatter.formatAttributed(word)
    }
    public var isAttributed: Bool { get { return formatter.isAttributed}}
    
    //
    // Template Method
    //
    public func setLabelText(_ label: UILabel?, _ word : String) {
        if formatter.isAttributed {
            label?.attributedText = formatter.formatAttributed(word)
        } else {
            label?.text = formatter.format(word)
        }
    }
    
    //
    // Factory method for creating required formatter
    //
    public func newSearch(_ query : String, _ searchType : SearchType){
        switch searchType {
            case .anagram:
                formatter = SubAnagramFormatter(query)
            case .blanks:
                formatter = BlankFormatter(query, color: highlightColor)
            case .supergram:
                formatter = SupergramFormatter(query, color: highlightColor)
            default:
                formatter = defaultFormatter
            
        }
    }
}
