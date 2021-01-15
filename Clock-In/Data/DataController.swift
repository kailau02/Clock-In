//
//  DataController.swift
//  Clock-In
//
//  Created by Kai Lau on 12/25/20.
//

import Foundation

let defaults = UserDefaults.standard

public var Revenue: Double{
    get{
        let hoursRevenue = Double(Hours) * 15.0
        var jobsRevenue : Double = 0
        if Jobs != nil{
            for job in Jobs!{
                jobsRevenue += job.revenue ?? 0
            }
        }
        return hoursRevenue + jobsRevenue
    }
}

public var Hours : Double{
    get{
        if defaults.valueExists(forKey: "hours") {return defaults.double(forKey: "hours")}
        else {return 0.0}
    }
    set (newValue){
        defaults.setValue(newValue, forKey: "hours")
    }
}

public var Jobs : [JobFinal]?{
    get{
        if let jobsData = UserDefaults.standard.data(forKey: "jobs"),
            let jobs = try? JSONDecoder().decode([JobFinal].self, from: jobsData) {
            return jobs
        }
        return nil
    }
    set (newValue){
        if let encoded = try? JSONEncoder().encode(newValue) {
            defaults.set(encoded, forKey: "jobs")
        }
    }
}

extension UserDefaults {

    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

}
