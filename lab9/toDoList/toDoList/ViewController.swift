//
//  ViewController.swift
//  toDoList
//
//  Created by Brian Aldrin Pagsolingan on 2026-03-31.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var taskTextField: UITextField!
    @IBAction func addTask(_ sender: Any) {
        guard let text = taskTextField.text, !text.isEmpty else {return}
        let newTask = ToDoTask(context: context)
        newTask.name = text
        newTask.id = UUID()
        
        do{
            try context.save()
            taskTextField.text = ""
        }catch{
            print("Error saving task: \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

