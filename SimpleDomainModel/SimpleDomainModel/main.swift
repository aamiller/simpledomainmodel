//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        if to == currency { return Money(amount: amount, currency : currency) }
        switch currency {
        case "USD":
            switch to {
            case "GBP":
                return Money(amount: amount / 2, currency: "GBP")
            case "CAN":
                return Money(amount: Int(Double(amount) * 1.25), currency: "CAN")
            case "EUR":
                return Money(amount: Int(Double(amount) * 1.5), currency: "EUR")
            default: print("Unexpected currency")
            }
        case "GBP":
            switch to {
            case "USD":
                return Money(amount: amount * 2, currency: "USD")
            case "CAN":
                return Money(amount: Int((Double(amount) * 2 * 1.25)), currency: "CAN")
            case "EUR":
                return Money(amount: Int((Double(amount) * 0.5 * 1.5)), currency: "CAN")
            default: print("Unexpected currency")
            }
        case "CAN":
            switch to {
            case "USD":
                return Money(amount: Int(Double(amount) / 1.25), currency: "USD")
            case "GBP":
                return Money(amount: Int(Double(amount) / 1.25) / 2, currency: "GBP")
            case "EUR":
                return Money(amount: Int((Double(amount) * (4/5) * 1.5)), currency: "CAN")
            default: print("Unexpected currency")
            }
        case "EUR":
            switch to {
            case "USD":
                return Money(amount: Int(Double(amount) / 1.5), currency: "USD")
            case "GBP":
                return Money(amount: Int(Double(amount) / 1.5 * 2), currency: "GBP")
            case "CAN":
                return Money(amount: Int(Double(amount) / 1.5 * 1.25), currency: "CAN")
            default: print("Unexpected currency")
            }
        default: print("Unexpected currency")
        }
        return Money(amount: -1, currency: "ERROR")
    }
    
    public func add(_ to: Money) -> Money {
        if to.currency != currency {
            return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
        } else {
            return Money(amount: amount + to.amount, currency: currency)
        }
    }
    public func subtract(_ from: Money) -> Money {
        if from.currency != currency {
            return Money(amount: from.amount - self.convert(currency).amount, currency: from.currency)
        } else {
            return Money(amount: from.amount + amount, currency: currency)
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case let .Hourly(hourly): return Int(Double(hourly) * Double(hours))
        case let .Salary(salary): return salary
        }
    }
    
    open func raise(_ amt : Double) {
        switch type {
        case let .Hourly(hourly):
            self.type = .Hourly(hourly + amt)
        case let .Salary(salary):
            self.type = .Salary(salary + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return _job }
        set(value) {
            if age > 15 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return _spouse }
        set(value) {
            if (spouse == nil) && (age > 18) {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        //"[Person: firstName: Ted lastName: Neward age: 45 job: Salary(1000) spouse: Charlotte]"
        let job : String = _job?.title ?? "nil"
        let spouse : String = _spouse?.firstName ?? "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        members.append(contentsOf: [spouse1, spouse2])
    }
    
    open func haveChild(_ child: Person) -> Bool {
        for p in members {
            if p._spouse != nil && p.age >= 21 {
                members.append(contentsOf: [child])
                return true
            }
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var sum : Int = 0
        for person in members {
            if let job = person._job {
                sum = sum + job.calculateIncome(2000)
            }
        }
        return sum
    }
}

