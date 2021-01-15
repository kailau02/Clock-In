//
//  HoursVC.swift
//  Clock-In
//
//  Created by Kai Lau on 12/25/20.
//

import UIKit

class HoursVC: UIViewController {
    
    
    var hoursCount = 0.0 {
        didSet{
            HoursTxt.text = String(hoursCount)
            Hours = self.hoursCount
            setRevenue()
        }
    }
    
    
    @IBOutlet weak var HoursView: UIView!
    @IBOutlet weak var HoursTxt: UILabel!
    @IBOutlet weak var MoneyTxt: UILabel!
    
    @IBOutlet var HourBtns: [UIButton]!
    
    
    @IBAction func AddPressed(_ sender: Any) {
        hoursCount += 1
    }
    @IBAction func AddHalfPressed(_ sender: Any) {
        hoursCount += 0.5
    }
    
    @IBAction func SubtractPressed(_ sender: Any) {
        if hoursCount > 0.0{
            hoursCount -= 1.0
        }
        if hoursCount < 0{
            hoursCount = 0.0
        }
    }
    
    @IBAction func ClearPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Clear Hours", message: "Are you sure you want to clear your hours?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: {_ in
            self.hoursCount = 0.0
        }))
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData(){
        hoursCount = Hours
        setRevenue()
    }
    
    func setupElements(){
        MoneyTxt.layer.cornerRadius = MoneyTxt.frame.height / 4.0
        MoneyTxt.layer.masksToBounds = true
        HoursView.layer.cornerRadius = HoursView.frame.width / 2.0
        
        HoursTxt.text = String(hoursCount)
        for btn in HourBtns{
            btn.layer.masksToBounds = true

            if btn.tag == 0{
            btn.layer.cornerRadius = btn.frame.height / 5.0
            }
            else{
                btn.layer.cornerRadius = btn.frame.height / 8.0
            }
        }
        
    }
    
    func setRevenue(){
        MoneyTxt.text = "$" + String(Revenue)
    }
    
}
