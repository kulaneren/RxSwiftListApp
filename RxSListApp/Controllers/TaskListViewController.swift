//
//  TaskListViewController.swift
//  RxSListApp
//
//  Created by eren kulan on 20/10/2019.
//  Copyright © 2019 eren kulan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var sgcPriority: UISegmentedControl!
    @IBOutlet weak var tblList: UITableView!
    
    private var disposeBag = DisposeBag()
    //    private var tasks = Variable<[Task]>([])
    private var tasks = BehaviorRelay<[Task]>(value: [])
    
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers.first as? AddTaskViewController else {
            return
        }
        
        vc.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                let priority = Priority(rawValue: self.sgcPriority.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        }else {
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
        
        self.tblList.reloadData()
    }
    
    //MARK: SegmentedView events
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tblList.reloadData()
        }
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblList.dequeueReusableCell(withIdentifier: "taskTblListCellIdentifier", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        return cell
    }
    
    
}
