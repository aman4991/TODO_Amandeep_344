//
//  EditViewController.swift
//  FinalAssignment
//
//  Created by user174568 on 6/27/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    var taskData = Tasks()
    var filterArray = [Tasks]()
    
    @IBOutlet var taskName: UITextField!
    @IBOutlet var dayRequired: UITextField!
    @IBOutlet var dayCompleted: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.text = taskData.taskname
        dayRequired.text = String(taskData.dayrequired)
        dayCompleted.text = String(taskData.daycompleted)
        loadFromCoreData()
        
    }
    
    func updateData(){
        
        //Core data manage context
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let taskNm = taskName.text
        let daysReq = Int(dayRequired.text!)
        let daysComp = Int(dayCompleted.text!)
        
        taskData.setValue(taskNm, forKey: "taskname")
        taskData.setValue(daysReq, forKey: "dayrequired")
        taskData.setValue(daysComp, forKey: "daycompleted")
        do{
            try context.save()
        }catch let error as NSError{
            print("Error Could not save Data. \(error),\(error.userInfo)")
        }
    }
    
    @IBAction func updateTask(_ sender: Any) {
        
        updateData()
        navigationController?.popViewController(animated: true)
    }
    
    func loadFromCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            filterArray = try context.fetch(Tasks.fetchRequest())
            print(filterArray)
        }catch let error as NSError{
            print("Error Could not save Data. \(error),\(error.userInfo)")
        }
    }
}
