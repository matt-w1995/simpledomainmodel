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
    var inUSD = 0
    switch currency {
    case "GBP":
        inUSD = amount * 2
    case "EUR":
        inUSD = amount * 2 / 3
    case "CAN":
        inUSD = amount * 4 / 5
    default:
        inUSD = amount
    }
    
    switch to {
    case "GBP":
        return Money(amount: inUSD / 2, currency: "GBP")
    case "EUR":
        return Money(amount: (inUSD * 3) / 2, currency: "EUR")
    case "CAN":
        return Money(amount: (inUSD * 5) / 4, currency: "CAN")
    case "USD":
        return Money(amount: inUSD, currency: "USD")
    default:
        return Money(amount: amount, currency: currency)
    }
  }
  
  public func add(_ to: Money) -> Money {
    let convertedCurrency = self.convert(to.currency)
    return Money(amount: to.amount + convertedCurrency.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let convertedCurrency = from.convert(currency)
    return Money(amount: amount - convertedCurrency.amount, currency: from.currency)
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
    switch self.type {
    case let JobType.Salary(income):
        return income
    case let JobType.Hourly(income):
        return Int(income * Double(hours))
    }
  }

  open func raise(_ amt : Double) {
    switch self.type {
    case let JobType.Hourly(income):
        self.type = JobType.Hourly(income + amt)
    case let JobType.Salary(income):
        self.type = JobType.Salary(income + Int(amt))
    }
  }
}
//
//////////////////////////////////////
//// Person
////
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {return _job}
    set(value) {
        _job = (self.age >= 16) ? value : nil
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {return _spouse}
    set(value) {
        _spouse = (self.age >= 18) ? value : nil
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
   return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
  }
}
//
//////////////////////////////////////
//// Family
////
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if(spouse1._spouse == nil && spouse2._spouse == nil) {
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if(members[0].age > 21 || members[1].age > 21) {
        self.members.append(child)
        return true
    }
    return false
  }

  open func householdIncome() -> Int {
    var total = 0
    for person in members {
        if(person.job != nil) {
            total += person.job!.calculateIncome(2000)
        }
    }
    return total
  }
}
//
//
//
//
//
