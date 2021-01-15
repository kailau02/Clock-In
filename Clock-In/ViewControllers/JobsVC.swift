//
//  JobsVC.swift
//  Clock-In
//
//  Created by Kai Lau on 12/25/20.
//

import UIKit

class JobsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MoneyTxt: UILabel!
    
    @IBOutlet var JobBtns: [UIButton]!
    
    @IBAction func ClearPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Clear Jobs", message: "Are you sure you want to clear your hours?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: {_ in
            Jobs = nil
            self.tableView.reloadData()
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    let cellIdentifier = "cell"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        setupElements()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func setupElements(){
        MoneyTxt.layer.cornerRadius = MoneyTxt.frame.height / 4.0
        MoneyTxt.layer.masksToBounds = true
        for btn in JobBtns{
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = btn.frame.height / 5.0
        }
    }
    
    func loadData(){
        tableView.reloadData()
        setRevenue()
    }
    
    func setRevenue(){
        MoneyTxt.text = "$" + String(Revenue)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}

}
extension JobsVC{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Jobs != nil{
            return Jobs!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        cell.selectionStyle = .none
        if Jobs != nil{
            let index = indexPath.row
            cell.textLabel!.text = Jobs![index].title
            return cell
        }
        else{
            return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if var j = Jobs{
                j.remove(at: indexPath.row)
                Jobs = j
                self.loadData()
            }
        }
    }
}
