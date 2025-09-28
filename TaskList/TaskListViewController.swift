//
//  ViewController.swift
//  TaskList
//
//  Created by Альбек Халапов on 28.09.2025.
//

import UIKit

final class TaskListViewController: UITableViewController {
    private let storageManager = StorageManager.shared
    private var taskList: [ToDoTask] = []
    private let cellID = "task"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        taskList = storageManager.fetchData()
        tableView.reloadData()
    }
    
    @objc private func addNewTask() {
        showAlert(withTitle: "New Task", andMessage: "What do you want to do?")
    }
    
    private func showAlert(withTitle title: String, andMessage message: String, task: ToDoTask? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.title
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            guard let inputText = alert.textFields?.first?.text, !inputText.isEmpty else { return }
            if let task = task {
                task.title = inputText
                storageManager.saveContext()
                if let index = taskList.firstIndex(of: task) {
                    tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            } else {
                let newTask = storageManager.save(inputText)
                taskList.append(newTask)
                tableView.insertRows(at: [IndexPath(row: taskList.count - 1, section: 0)], with: .automatic)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let taskToDelete = taskList[indexPath.row]
                
                storageManager.context.delete(taskToDelete)
                storageManager.saveContext()
                
                taskList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        showAlert(withTitle: "Edit Task", andMessage: "Update your task", task: task)
    }
    
    
    // MARK: - Setup UI
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = .milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}


