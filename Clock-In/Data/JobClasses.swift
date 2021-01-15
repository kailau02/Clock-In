//
//  JobClasses.swift
//  Clock-In
//
//  Created by Kai Lau on 12/25/20.
//

import Foundation

public class JobFinal : Codable{
    var title : String?
    var revenue : Double?
}

public struct JobData {
    
    func getJobAt(index : Int) -> JobClass{
        switch index{
        case 0:
            return JobClass(maxPeople: 2, title: "Weekday Office", maxMoney: 10.0)
        case 1:
            return JobClass(maxPeople: 3, title: "Weekend Office", maxMoney: 90.0)
        case 2:
            return JobClass(maxPeople: 1, title: "House Cleaning", maxMoney: 20.0)
        case 3:
            return JobClass(maxPeople: 2, title: "Groceries", maxMoney: 10.0)
        case 4:
            return JobClass(maxPeople: 1, title: "Cooking", maxMoney: 30.0)
        case 5:
            return JobClass(maxPeople: 1, title: "Other", maxMoney: 0.0)
        default:
            return JobClass(maxPeople: 1, title: "Null", maxMoney: 0.0)
            
        }
    }
}

public class JobClass {
    let maxPeople : Int!
    let maxMoney : Double!
    var title : String!
    init(maxPeople : Int, title: String, maxMoney: Double) {
        self.maxPeople = maxPeople
        self.maxMoney = maxMoney
        self.title = title
    }
}

public func FinalizeJob(jobIndex : Int, workers : Int, overrideMoney : Double, overrideTitle : String) -> JobFinal{
    let tempJob = JobFinal()
    let jobAtIndex = JobData().getJobAt(index: jobIndex)
    if jobIndex == 5{
        tempJob.title = overrideTitle + " "
    }
    else{
        tempJob.title = jobAtIndex.title + " "
    }
    if workers > 0 {
        tempJob.title! += "(ppl:" + String(workers) + ") "
    }
    let df = DateFormatter()
    df.dateFormat = "MM-dd-YY"
    let now = df.string(from: Date())
    tempJob.title! += now + " : "
    if jobIndex == 5 {
        tempJob.title! += "$" + String(overrideMoney)
        tempJob.revenue = overrideMoney
    }
    else if jobAtIndex.maxPeople > 1 {
        let money = jobAtIndex.maxMoney / Double(workers)
        tempJob.title! += "$" + String(money)
        tempJob.revenue = money
    }
    else {
        let money = jobAtIndex.maxMoney!
        tempJob.title! += "$" + String(money)
        tempJob.revenue = money
    }
    
    return tempJob
}
