//
//  TaskListViewController.swift
//  toDoList
//
//  Created by Brian Aldrin Pagsolingan on 2026-03-31.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [ToDoTask] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()

        // Do any additional setup after loading the view.
    }
    func fetchTasks() {
        do{
            tasks = try context.fetch(ToDoTask.fetchRequest())
            tableView.reloadData()
        }catch{
            print("Fetch Failed")
        }
    }
    
    func saveContext() {
        do{
            try context.save()
            tableView.reloadData()
        }catch{
            print("Error saving")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
    
    // de;ete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let taskToDelete = tasks[indexPath.row]
            context.delete(taskToDelete)
            tasks.remove(at: indexPath.row)
            saveContext()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // swipe to edit
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let taskToEdit = tasks[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Task", message: "Update your task", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.text = taskToEdit.name
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default){ _ in
            if let updatedText = alert.textFields?.first?.text, !updatedText.isEmpty{
                taskToEdit.name = updatedText
                self.saveContext()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
