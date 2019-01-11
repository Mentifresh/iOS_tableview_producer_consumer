//
//  ViewController.swift
//  tableview_producer_consumer
//
//  Created by Daniel Kilders Díaz on 11/01/2019.
//  Copyright © 2019 dankil. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var numberOfRows = 1
    var timerArray = [Timer]()
    
    let cellIdentifier = "cellID"
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        
        return table
    }()
    
    let producerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Producer", for: .normal)
        button.backgroundColor = .green
        
        return button
    }()
    
    let consumerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Consumer", for: .normal)
        button.backgroundColor = .red
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureTableview()
        producerButton.addTarget(self, action: #selector(addProducer), for: .touchUpInside)
        consumerButton.addTarget(self, action: #selector(addConsumer), for: .touchUpInside)
        
        setupTableviewConstraints()
        setupButtonConstraints()
        
    }

    // MARK: - Tableview data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = String(indexPath.row)
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        
        return cell
    }
    
    // MARK: - Button action methods
    
    @objc func addProducer() {
        // Timed that adds every 3s a new cell
        let timer = Timer.init(timeInterval: 3, repeats: true) { (timer) in
            self.numberOfRows += 1
            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
            
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    @objc func addConsumer() {
        // Timer that removes every 4s an existing cell
        let timer = Timer.init(timeInterval: 4, repeats: true) { (timer) in
            // If number of rows higher than 0, remove a cell
            if self.numberOfRows >= 1 {
                self.numberOfRows -= 1
                let indexPath = IndexPath(row: 0, section: 0)
                
                // Get cell and add some visual feedback
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.backgroundColor = .red
                
                // Delete cell
                self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            }
        }
        RunLoop.main.add(timer, forMode: RunLoop.Mode.default)
    }
    
    // MARK: - Helper Methods
    
    func configureTableview() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func setupTableviewConstraints() {
        // Add tableview to view
        self.view.addSubview(tableView)
        
        // setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9)
            ])
    }
    
    func setupButtonConstraints() {
        // Add buttons to view
        self.view.addSubview(consumerButton)
        self.view.addSubview(producerButton)
        
        let halfScreenSizeMinusMargin = self.view.frame.width / 2 - 10
        
        // setup constraints
        NSLayoutConstraint.activate([
            consumerButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            consumerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            consumerButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            consumerButton.widthAnchor.constraint(equalToConstant: halfScreenSizeMinusMargin)
            ])
        
        NSLayoutConstraint.activate([
            producerButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            producerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            producerButton.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            producerButton.widthAnchor.constraint(equalToConstant: halfScreenSizeMinusMargin)
            ])
    }
}

