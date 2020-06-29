//
//  AddViewController.swift
//  FinalAssignment
//
//  Created by user174568 on 6/27/20.
//  Copyright © 2020 user174568. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    let temp = 0
    var daysReq = 0
    var daysComp = 0
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var daysRequired: UITextField!
    @IBOutlet weak var daysCompleted: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTask(_ sender: Any) {
        
        daysReq = Int(daysRequired.text!) ?? 0
        daysComp = Int(daysCompleted.text!) ?? 0
        
        if daysComp > daysReq{
            daysCompletedAction()
        }else{
            saveTask(todo: taskTitle.text!, totalDays: Int(daysRequired.text!)!, daysCompleted: Int(daysCompleted.text!)!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func daysCompletedAction(){
        let alert = UIAlertController(title: "Completed Days can't be greater then no of days required", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.daysReq = Int(self.daysRequired.text!) ?? 0
            self.daysComp = Int(self.daysCompleted.text!) ?? 0
            if self.daysComp > self.daysReq{
                self.daysCompletedAction()
            }
        }))
        
        daysCompleted.text = String(temp)
        self.present(alert, animated: true)
    }
    
    func saveTask(todo : String,totalDays : Int,daysCompleted : Int){
        // Coredata
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let task = Tasks(context: context)
        
        task.taskname = todo
        task.dayrequired = Int64(totalDays)
        task.daycompleted = Int64(daysCompleted)
        do{
            try context.save()
        }catch let error as NSError{
            print("Error Could not save Data. \(error),\(error.userInfo)")
        }
    }
}
