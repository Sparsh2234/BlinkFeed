//
//  SettingsController.swift
//  BlinkFeed
//
//  Created by Sparsh Pai on 2024-03-17.
//

import Foundation
import UIKit
class SettingsController: UIViewController {
    
    @IBOutlet weak var preferencesTableView: UITableView!
    
    var optionsList = ["Politics", "Business", "Technology", "Entertainment", "Sports", "Health", "Science"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferencesTableView.delegate = self
        preferencesTableView.dataSource = self
        
        if let savedTopics = UserDefaults.standard.array(forKey: "SelectedTopics") as? [String] {
            DataManager.shared.selectedTopicsList = savedTopics
        }
    }
    
}


extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = optionsList[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        let toggle = UISwitch()
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: #selector(didTapToggle), for: .touchUpInside)
        cell.accessoryView = toggle
        
        if DataManager.shared.selectedTopicsList.contains(optionsList[indexPath.row]) {
            toggle.isOn = true
        } else {
            toggle.isOn = false
        }
        
        return cell
    }
    
    @objc func didTapToggle(_ sender: UISwitch) {
        let rowIndex = sender.tag
        let labelText = optionsList[rowIndex]
        DataManager.shared.didChangeSelection = true
        if sender.isOn {
            DataManager.shared.selectedTopicsList.append(labelText)
        } else {
            DataManager.shared.selectedTopicsList.remove(at: DataManager.shared.selectedTopicsList.firstIndex(of: labelText)!)
        }
        UserDefaults.standard.set(DataManager.shared.selectedTopicsList, forKey: "SelectedTopics")
    }
}
