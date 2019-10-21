//
//  AddTaskViewController.swift
//  RxSListApp
//
//  Created by eren kulan on 20/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return self.taskSubject.asObservable()
    }
    
    @IBOutlet weak var sgcPriority: UISegmentedControl!
    @IBOutlet weak var txtTaskTitle: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue: self.sgcPriority.selectedSegmentIndex), let title = txtTaskTitle.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        self.dismiss(animated: true, completion: nil)
    }
}
