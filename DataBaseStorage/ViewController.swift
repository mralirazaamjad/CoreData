//
//  ViewController.swift
//  DataBaseStorage
//
//  Created by Ali Raza Amjad on 01/01/2020.
//  Copyright © 2020 Ali Raza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblCoreData: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    
    let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var arrayProfile = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblCoreData.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        
        arrayProfile = DatabaseHelper.fetchAllRecords("Profile", filter: nil, sortDiscripter: [], fetchLimit: 0) as! [Profile]
        tblCoreData.reloadData()
    }

    @IBAction func actionAdd(_ sender: UIBarButtonItem) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddUpdateViewController") as! AddUpdateViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let objProfile = arrayProfile[indexPath.row]
        cell?.textLabel?.text = objProfile.name
        cell?.detailTextLabel?.text = objProfile.address
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddUpdateViewController") as! AddUpdateViewController
        vc._objProfile = arrayProfile[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let objProfile = self.arrayProfile[indexPath.row]
            let predicate = NSPredicate(format: "name == %@ AND address == %@", objProfile.name!, objProfile.address!)
            let arrayDbProfile = DatabaseHelper.fetchAllRecords("Profile", filter: predicate, sortDiscripter: [], fetchLimit: 0) as! [Profile]
            if !arrayDbProfile.isEmpty {
                DatabaseHelper.deleteObjec(arrayDbProfile[0])
            }
            
            self.arrayProfile.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
}

