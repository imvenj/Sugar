//
//  String+Ruby.swift
//  Sugar Example
//
//  Created by 朱文杰 on 15/11/13.
//  Copyright © 2015年 朱文杰. All rights reserved.
//

import Foundation

//MARK: - String Operators
// Because % is a system operator, we use %% instead
// Not all the functionality of the ruby % operator 
// are implemented, like dictionary replacement
infix operator %% { associativity left precedence 140 }
@available(iOS 7.0, OSX 10.9, *)
public func %%(lhs: String, rhs: [CVarArgType]) -> String{
    return String(format: lhs, arguments: rhs)
}

@available(iOS 7.0, OSX 10.9, *)
public func *(lhs: String, rhs:Int) -> String {
    if rhs < 0 {
        fatalError("String can not multiply by negtive number.")
    }
    var result = ""
    for var i = 0; i < rhs; ++i {
        result += lhs
    }
    return result
}

// This operator is different from Ruby's implementation.
// Since manipulate with unicode point is difficult, we
// are not convert Int to char while using this operator
// like ruby did.
infix operator << { associativity left precedence 140 }
@available(iOS 7.0, OSX 10.9, *)
public func <<<T>(lhs: String, rhs: T) -> String {
    return lhs + String(rhs)
}

infix operator <=> { associativity left precedence 140 }
@available(iOS 7.0, OSX 10.9, *)
public func <=>(lhs: String, rhs: String) -> Int {
    if lhs > rhs { return 1 }
    else if lhs == rhs { return 0 }
    else { return -1 }
}

@available(iOS 7.0, OSX 10.9, *)
public extension String {
    // Static function
    static func UUIDString() -> String {
        let now = NSDate()
        let timeStamp = now.timeIntervalSince1970
        let str = String(timeStamp)
        let hash = str.md5
        let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calender!.components([.Minute, .Second], fromDate: now)
        let minute = dateComponents.minute
        let second = dateComponents.second
        let selectedIndices = (minute % 32, second % 32)
        let range = min(selectedIndices.0, selectedIndices.1)...max(selectedIndices.0, selectedIndices.1)
        return hash[range]
    }

    // Byte related methods are not included currently
    // b(), bytes(), bytesize(), byteslice()

    subscript(index: Int) -> String {
        let startIndex = self.startIndex
        let position = startIndex.advancedBy(index)
        let endIndex = startIndex.advancedBy(index+1)
        let range = Range<Index>(start:position, end:endIndex)
        return substringWithRange(range)
    }

    subscript(intRange: Range<Int>) -> String {
        let stringOrigin = self.startIndex
        let startIndex = stringOrigin.advancedBy(intRange.startIndex)
        let endIndex = startIndex.advancedBy(intRange.endIndex - intRange.startIndex)
        let range = Range<Index>(start:startIndex, end:endIndex)
        return substringWithRange(range)
    }
    
    subscript(nsRange: NSRange) -> String {
        let range = rangeFromNSRange(nsRange)
        return self[range]
    }

    func asciiOnly() -> Bool {
        return fastestEncoding == NSASCIIStringEncoding
    }

    func capitalize() -> String {
        return capitalizedString
    }

    func casecomp(rhs:String) -> Int {
        return lowercaseString <=> rhs.lowercaseString
    }

    func center(size: Int, padString:String = " ") -> String {
        let padSize = padString.characters.count
        if padSize == 0 { fatalError("padString can not be zero length") }
        let count = characters.count
        if characters.count <= size { return self }
        let leftPadSpace = (size - count) / 2
        let rightPadSpace = leftPadSpace + (size - count) % 2
        if padSize == 1 {
            return padString * leftPadSpace + self + padString * rightPadSpace
        }
        else {
            var (leftPad, rightPad) = ("", "")
            for var i = 0, j = 0; i < leftPadSpace; ++i, ++j {
                if j % padSize == 0 { j = 0 }
                leftPad += padString[j]
            }
            for var i = 0, j = 0; i < rightPadSpace; ++i, ++j {
                if j % padSize == 0 { j = 0 }
                rightPad += padString[j]
            }
            return leftPad + self + rightPad
        }
    }

    // May not a good implementation, just mimic ruby's chomp method
    func chomp(separator: String? = nil) -> String {
        func isChar(char: Character, inSet set: NSCharacterSet) -> Bool {
            return set.characterIsMember(String(char).utf16.first!)
        }
        var result = self
        let lastCharIndex = endIndex.advancedBy(-1)
        let range = Range<Index>(start:lastCharIndex, end:endIndex)
        let lastCharString = result.substringWithRange(range)
        if isChar(lastCharString.characters.first!, inSet: NSCharacterSet.newlineCharacterSet()) {
            while (result.hasSuffix(lastCharString)) {
                guard let range = result.rangeOfString(lastCharString, options: .BackwardsSearch, range: nil, locale: nil) else { return result }
                result.removeRange(range)
            }
        }
        else {
            result.removeRange(range)
        }

        return result
    }

    func chop(inPlace: Bool = false) -> String {
        var result = self
        let lastCharIndex = endIndex.advancedBy(-1)
        let range = Range<Index>(start:lastCharIndex, end:endIndex)
        result.removeRange(range)
        return result
    }

    mutating func clear() {
        self = ""
    }

    // chr, chomp!, chop!,  are not implemented

    // codepoints not implemented, since String has better solutions
    func concat<T>(obj: T) -> String {
        return self << obj
    }

    func count() -> Int {
        return characters.count
    }

    // crypt not implemented

    func delete(words: [String]) -> String {
        if words.count == 0 { return self }
        let charset = NSMutableCharacterSet(charactersInString: words[0])
        if words.count >= 2 {
            for var i = 1; i < words.count; ++i {
                let s = NSCharacterSet(charactersInString: words[i])
                charset.formIntersectionWithCharacterSet(s)
            }
        }
        let components = componentsSeparatedByCharactersInSet(charset)
        var result = ""
        for component in components {
            result += component
        }
        return result
    }

    // Not like ruby's delete!, this method does not return.
    mutating func deleteInPlace(words: [String]) {
        self = delete(words)
    }

    func downcase() -> String {
        return lowercaseString
    }

    mutating func downcaseInPlace() {
        self = lowercaseString
    }

    // dump not implemented

    // each_byte, each_codepoint not implemented

    func eachChar( invocation: ((_:Character) -> Void) ) {
        for char in characters {
            invocation(char)
        }
    }

    func eachLine( invocation: ((_:String) -> Void) ) {
        let lines = componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        for line in lines {
            invocation(line)
        }
    }

    var empty: Bool {
        return isEmpty
    }

    func encode(toEncoding: NSStringEncoding, fromEncoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        guard let data = dataUsingEncoding(fromEncoding) else { return nil }
        let result = String(data: data, encoding: toEncoding)
        return result
    }

    // encoding is not applicable; encode!, get_byte not implemented
    // force_encoding is not applicable

    func endWith(suffix: String) -> Bool {
        return hasSuffix(suffix)
    }

    func gsub(pattern:String, replacement:String) -> String? {
        var result: String? = self
        result = gsub(pattern) { (match) in
            return ""
        }
        return result
    }

    // Not good... Anyway to get rid of one of the loops?
    func gsub(pattern:String, invocation:( (_: NSTextCheckingResult) -> String )) -> String? {
        var result: String? = self
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive) else { return nil }
        let matches = regex.matchesInString(self, options: [], range: NSRange(location:0, length: characters.count))
        var replaces: [(String, String)] = []
        for match in matches {
            replaces.append( (self[match.range], invocation(match)) )
        }
        for replace in replaces {
            result = result?.stringByReplacingOccurrencesOfString(replace.0, withString: replace.1)
        }
        return result
    }

    // gsub! not implemented
    // hash is already implemented by standard library
    // hex not implemented

    func include(subString: String) -> Bool {
        return containsString(subString)
    }

    func index(subString: String, isRegex: Bool = false, isReverse: Bool = false,  offset: Int = 0) -> Int? {
        let stringLength = characters.count
        let searchOffset = (stringLength + offset) % stringLength
        let searchRange = Range<Index>(start: startIndex.advancedBy(searchOffset), end: endIndex)
        var options: NSStringCompareOptions = isRegex ? [.RegularExpressionSearch] : []
        if isReverse { options.insert(.BackwardsSearch) }
        guard let range = rangeOfString(subString, options:options, range: searchRange, locale: nil) else { return nil }
        return startIndex.distanceTo(range.startIndex)
    }

    mutating func insert(index:Int, subString: String) -> String {
        let offset = index > 0 ? index : characters.count + index + 1
        insertContentsOf(subString.characters, at: startIndex.advancedBy(offset))
        return self
    }

    // inspect is not implemented
    // intern is not applicaable

    func length() -> Int {
        return characters.count
    }

    func lines() -> [String] {
        return componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
    
    func ljust(totalLength:Int, padString: String = " ") -> String {
        let stringLength = characters.count
        if totalLength <= stringLength {
            return self
        }
        else {
            var result = self
            let padSize = padString.characters.count
            for var i = stringLength, j = 0; i < totalLength; ++i, ++j {
                if j % padSize == 0 { j = 0 }
                result += padString[j]
            }
            return result
        }
    }
    
    func lstrip() -> String {
        var result = self
        guard let range = rangeOfString("^\\s+", options: [.RegularExpressionSearch, .AnchoredSearch], range: nil) else { return self }
        result.replaceRange(range, with: "")
        return result
    }
    
    // Not like ruby, this method will not return
    mutating func lstripInPlace() {
        self = lstrip()
    }
    
    func match(pattern:String, offset: Int = 0, invocation:((NSTextCheckingResult) -> Void)? = nil) -> NSTextCheckingResult? {
        let stringLength = characters.count
        let searchOffset = (stringLength + offset) % stringLength
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive) else { return nil }
        return regex.firstMatchInString(self, options: [], range: NSRange(location: searchOffset, length: stringLength - searchOffset))
    }
        
    // next/succ, oct, ord not implemented
    
    func prepend(prefix: String) -> String {
        return prefix + self
    }
    
    mutating func replace(anotherString: String) -> String {
        self = anotherString
        return self
    }
    
    func reverse() -> String {
        return String(characters.reverse())
    }
    
    mutating func reverseInPlace() -> String {
        self = reverse()
        return self
    }
    
    // The implementation is done in index()
    func rindex(subString: String, isRegex: Bool = false, offset: Int = 0) -> Int? {
        return index(subString, isRegex: isRegex, isReverse:true, offset: offset)
    }
    
    func rjust(totalLength: Int, padString: String = " ") -> String {
        let stringLength = characters.count
        if totalLength <= stringLength {
            return self
        }
        else {
            var result = ""
            let padSize = padString.characters.count
            let stringLength = characters.count
            for var i = 0, j = 0; i < totalLength - stringLength; ++i, ++j {
                if j % padSize == 0 { j = 0 }
                result += padString[j]
            }
            result += self
            return result
        }
    }
    
    func rpartition(separator: String, isRegex: Bool = false) -> [String]? {
        //TODO: implement later.
        fatalError("not implemented")
    }
    
    func rstrip() -> String {
        var result = self
        guard let range = rangeOfString("\\s+$", options: [.RegularExpressionSearch, .AnchoredSearch], range: nil) else { return self }
        result.replaceRange(range, with: "")
        return result
    }
    
    // Not like ruby, this method will not return
    mutating func rstripInPlace() {
        self = rstrip()
    }
    
    //FIXME: ruby can use a block with variable amount of arguments. Maybe we can pass an array of matched strings or range?
    func scan(pattern:String, invocation:((NSTextCheckingResult) -> Void)? = nil) -> [NSTextCheckingResult]? {
        let stringLength = characters.count
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive) else { return nil }
        let matches = regex.matchesInString(self, options: [], range: NSRange(location: 0, length: stringLength))
        if matches.count == 0 {
            return nil
        }
        else {
            for match in matches {
                invocation?(match)
            }
            return matches
        }
    }

    // scrub, scrub!, setByte not implemented
    func size() -> Int {
        return characters.count
    }

    // slice is not implemented, maybe implemented later, part of the functionalities are implemented by subsctipt
    
    // the limit argument is not implemented.
    // now split() and split("") mimic ruby behavior, not componentsSeparatedByString behavior.
    func split(seperator: String? = nil, isRegex: Bool = false) -> [String] {
        if seperator == nil { return [self] }
        if isRegex {
            let __UUID = String.UUIDString()
            let tmpString = stringByReplacingOccurrencesOfString(seperator!, withString: __UUID, options: [.RegularExpressionSearch], range: nil)
            return tmpString.componentsSeparatedByString(__UUID)
        }
        else {
            if seperator == "" {
                var result: [String] = []
                for char in self.characters {
                    result.append(String(char))
                }
                return result
            }
            else {
                return componentsSeparatedByString(seperator!)
            }
        }
    }

    func squeeze() -> String {
        return gsub("\\s+", replacement: " ")!
    }

    mutating func squeezeInPlace() -> String {
        self = squeeze()
        return self
    }

    func startWith(prefix: String) -> Bool {
        return hasPrefix(prefix)
    }

    // white space and new line chars are all stripped
    // note: lstrip and rstrip are not trim newline chars
    // this behavior may change later
    func strip() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    mutating func stripInPlace() -> String {
        self = strip()
        return self
    }

    //TODO: sub() subInPlace()

    // succ, succ!, sum to_xxx unpack upto not implemented

    //TODO: swapcase(), swapcaseInPlace()

    //  tr and tr! not implemented. Maybe add later

    func upcase() -> String {
        return uppercaseString
    }

    mutating func upcaseInPlace() {
        self = uppercaseString
    }

    // not functions the same as the ruby's valid_encoding?
    func validEncoding(encoding: NSStringEncoding) -> Bool {
        guard let _ = dataUsingEncoding(encoding, allowLossyConversion: false) else { return false }
        return true
    }
}
