//: Playground - noun: a place where people can play

import UIKit
import Sugar

let base = "Hello"
base.ljust(20, padString: "abc")

base.lstrip()

var vbase = base
vbase.lstripInPlace()

base.match("H", offset: 9)?.range.location

base.match("H") {
    let capture = base[$0.range]
}

base.ljust(20)
base.ljust(20, padString: "abc")
base.rjust(20)
base.rjust(20, padString: "abc")

let myString = "<li><a href=\"https://google.com\">Google</a></li><li><a href=\"https://apple.com\">Apple</a></li>"

var result = ""
myString.scan("<a href=\"([^\"]+?)\">([^<]+?)</a>") { match in
    let keyRange = match[1]
    let valueRange = match[2]
    result = result + myString[keyRange] + ", "  + myString[valueRange] + "; "
}
result

let endIndex = myString.startIndex.advancedBy(2)
let subRange = Range<String.Index>(start: myString.startIndex, end: endIndex)

let testString = "test"
let nsrange = NSRange(location:0, length:500)
testString[nsrange]

myString.split("</[^>]+?>", isRegex: true)

myString.squeeze()
vbase.squeezeInPlace()
vbase = "H ello   Wor  l d"
vbase.squeezeInPlace()

vbase.validEncoding(NSUTF8StringEncoding)
vbase.fastestEncoding

"Size: %d" %% [12]
 
"good".split("")

let str1 = "The big brown fox jumps over the lazy dog."

str1.delete(["hello", "old"])
let str = "Hello, Hello, Hello"
str.partition("ll")
str.rpartition("ll")
str.partition("l+", isRegex: true)
str.index("l+", isRegex: true)
str.rindex("ll")

2 * 3
2 ** 3
5.upTo(9) { print($0) }
5.gcd(2)
27.gcd(9)
27.gcd(15)
27.lcm(9)
27.lcm(15)

"abc" <=> "bcd"

let dict = ["name" : "John Doe", "sex" : "Male", "Age": 30, "Nationality": "U.S."]
dict.invert()
dict.each { (key, value) in
    print("Key: \(key), value: \(value)")
}

dict.fetch("not exist") {
    print("\($0) not found")
}

var dict1 = ["a": 100, "b": 200]
let dict2 = ["b": 254, "c": 300]

dict1.merge(dict2)
dict1.merge(dict2) { (key, oldValue, value) -> Int in
    return value - oldValue
}
dict1.mergeInPlace(dict2) { (key, oldValue, value) -> Int in
    return value - oldValue
}
dict1

let arr = [1,2,3,4,5,6,7,8,9]
arr.at(-1)
arr.at(-9)
arr.at(-10)
arr.at(8)
arr.at(9)

var a = ["a", "b", "c"]

a.cycle(3) {
    print($0)
}

a.rotate(2)
a.rotate(-2)
a



let r = a.anyIf("b", ==)
r
a.deleteIf { $0 == "b" }
a

3.isBetween(1, 5)
3.isBetween(5, 1)
3.isBetween(3, 3)

var z: [Int?] = []
z = [1,2,3,4,nil,nil]

var t = Time(year: 2014, month: 11, day: 23, hour: 11, minute: 11, second: 11, calender: nil)
t?.year
t?.date

t = Time(year: 2015, month: 11, day: 19, hour: 0, minute: 0, second: 0, calender: nil)
t?.locale = NSLocale(localeIdentifier: "en_GB")
t?.isThursday
t?.mediumString
t?.locale = NSLocale.currentLocale()
t?.mediumString
let date = NSDate()
date.isIt(.Thursday)
let date1: NSDate
let date2 = NSDate()
date1 = date2

date1 == date2
date == date1
date < date1

date.year
date.month
date.day







