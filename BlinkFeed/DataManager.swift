//
//  DataManager.swift
//  BlinkFeed
//
//  Created by Sparsh Pai on 2024-03-18.
//
import Foundation
class DataManager {
    static let shared = DataManager()
    var selectedTopicsList: [String] = []
    var didChangeSelection: Bool = false
    private init() {}
}
