//
//  MovingInVC.swift
//  A2J_iOSApp
//
//  Created by Aristotelis Mitsiou on 14/04/2021.
//  Copyright © 2021 A2J. All rights reserved.
//

import UIKit

class MovingInVC: UIViewController {

    var dropButton = DropDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dropButton = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropButton.translatesAutoresizingMaskIntoConstraints = false
        dropButton.setTitle("Checklist", for: .normal)
        
        self.view.addSubview(dropButton)
        
        dropButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dropButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        dropButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        dropButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dropButton.dropView.dropList = ["Before Signing The Contract", "When You Are Moving In"]
    }
}

protocol DropDownPressed {
    func buttonPressed()
}

class DropDownButton: UIButton, DropDownPressed {
    
    func buttonPressed() {
        self.stopDropDown()
    }
    
    var dropView = DropDownView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brown
        self.setTitleColor(UIColor.white, for: .normal)
        
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    var height = NSLayoutConstraint()
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func stopDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
}


class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var dropList = [String]()
    var tableView = UITableView()
    var delegate : DropDownPressed!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.brown
        self.backgroundColor = UIColor.brown
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sections(in tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropList[indexPath.row]
        cell.backgroundColor = UIColor.brown
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.buttonPressed()
        print(dropList[indexPath.row])
    }
}
