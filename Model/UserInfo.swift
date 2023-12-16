//
//  UserInfo.swift
//  P2hacks
//
//  Created by 山本拓摩 on 2023/12/10.
//

import Foundation


struct UserInfo : Identifiable , Codable {
    var id: String
    var name: String
    var age: Int
    var job: String
    var weight: Int
    var change: Int
    var icon: String
    var friends: Array<String>
    
    var dictionary: [String: Any] {
        return [
          "id": id,
          "name": name,
          "age": age,
          "job": job,
          "weight": weight,
          "change": change,
          "icon": icon,
          "friends": friends
        ]
      }
    
    init(id: String, name: String, age: Int, job: String, weight: Int, change: Int, icon: String, friends: Array<String>) {
        self.id  = id
        self.name  = name
        self.age  = age
        self.job  = job
        self.weight  = weight
        self.change  = change
        self.icon  = icon
        self.friends  = friends
        
     }
    
    mutating func updataAll(data: UserInfo) {
        self.id  = data.id
        self.name  = data.name
        self.age  = data.age
        self.job  = data.job
        self.weight  = data.weight
        self.change  = data.change
        self.icon  = data.icon
        self.friends  = data.friends
    }
    
    mutating func updataName(data: String) {
        name = data
    }
    
    mutating func updataAge(data: Int) {
        age = data
    }
    
    mutating func updataJob(data: String) {
        job = data
    }
    
    mutating func updataWeight(data: Int) {
        weight = data
    }
    
    mutating func updataChange(data: Int) {
        change = data
    }
    
    mutating func updataIcon(data: String) {
        icon = data
    }
    
    mutating func addFriend(data: String) {
        friends.append(data)
    }

}
