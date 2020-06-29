//
//  ViewController.swift
//  FinalAssignment
//
//  Created by user174568 on 6/27/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit
import CoreData
class ViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var task = [Tasks]()
    var filtertask = [Tasks]()
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCoreData()
        filtertask = task
        tableview.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtertask = searchText.isEmpty ? task : task.filter({ (item: Tasks) -> Bool in
            return item.taskname!.range(of: searchText, options: .caseInsensitive) != nil
        })
        self.tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtertask.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let taskDetail = filtertask[indexPath.row]
        
        cell.title.text = taskDetail.taskname
        cell.totalDays.text = "Total Days : \(String(taskDetail.dayrequired))"
        cell.daysCompleted.text = "Days Worked : \(String(taskDetail.daycompleted))"
        
        let daysLeft = (taskDetail.dayrequired - taskDetail.daycompleted)
        if (daysLeft <= 0){
            cell.daysLeft.textColor = UIColor.red
            let fontsize : CGFloat = 16
            cell.daysLeft.font = UIFont.boldSystemFont(ofSize: fontsize)
            cell.daysLeft.text = "Completed"
            cell.backgroundColor = .green
        }
        else{
            let day = taskDetail.dayrequired - taskDetail.daycompleted
            if day == 1{
                cell.backgroundColor = .red
            }else{
                cell.backgroundColor = .none
            }
            cell.daysLeft.text = "Days Left : \(String(day))"
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentVc = UIStoryboard(name: "Main", bundle: nil)
        let destinationVc = currentVc.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        destinationVc.taskData = task[indexPath.row]
        navigationController?.pushViewController(destinationVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let tempTask = filtertask[indexPath.row]
            context.delete(tempTask)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do{
                task = try context.fetch(Tasks.fetchRequest())
            }catch let error as NSError{
                print("Error in deleting the data. \(error),\(error.userInfo)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    //Load Data
    func loadCoreData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let Context = appDelegate.persistentContainer.viewContext
        do{
            task = try Context.fetch(Tasks.fetchRequest())
        }
        catch let error as NSError{
            print("Error Could not save Data. \(error),\(error.userInfo)")
        }
    }
}


class TableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var totalDays: UILabel!
    @IBOutlet weak var daysCompleted: UILabel!
    @IBOutlet weak var daysLeft: UILabel!
    
}
