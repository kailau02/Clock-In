//
//  JobSelectVC.swift
//  Clock-In
//
//  Created by Kai Lau on 12/25/20.
//

import UIKit

class JobSelectVC: UIViewController{
    
    let jobData = JobData()
    
    @IBOutlet weak var JobPicker: UIPickerView!
    var selectedJob = 0
    
    @IBOutlet weak var OtherStackView: UIStackView!
    @IBOutlet weak var OtherTxtField: UITextField!
    
    @IBOutlet weak var MoneyTxtField: UITextField!
    
    @objc func textFieldChanged(textField: UITextField){
        var dollarFound = false
        var decimalIndex = -1
        var index = 0
        for char in MoneyTxtField.text! {
            print(char)
            if char == "$" { dollarFound = true }
            if char == "." { decimalIndex = index }
            index += 1
        }
        if !dollarFound { MoneyTxtField.text = "$" + MoneyTxtField.text!}
        if decimalIndex != -1 && MoneyTxtField.text!.count - 3 > decimalIndex {MoneyTxtField.text!.removeLast()}
    }
    
    @IBOutlet weak var WorkerNumPicker: UISegmentedControl!
    
    @IBOutlet weak var WorkerNumStackView: UIStackView!
    
    
    @IBOutlet var BtnCollection: [UIButton]!
    
    @IBAction func FinishPressed(_ sender: Any) {
        if WorkerNumPicker.selectedSegmentIndex == -1 {
            showError(msg: "Select the number of individuals who worked.")
            return
        }
        if selectedJob == 5 && ( OtherTxtField.text == "" || String(MoneyTxtField.text!.filter {!"0. ".contains($0)}) == "$"){
            showError(msg: "Make sure all fields are completed.")
            return
        }
        if JobData().getJobAt(index: selectedJob).maxPeople == 1 {
            WorkerNumPicker.selectedSegmentIndex = -1
        }
        let jobFinish = FinalizeJob(jobIndex: selectedJob, workers: WorkerNumPicker.selectedSegmentIndex + 1, overrideMoney: Double(String(MoneyTxtField.text!.filter {!"$".contains($0)})) ?? 0, overrideTitle: OtherTxtField.text ?? "")
        print(jobFinish.title)
        print(jobFinish.revenue)
        var jobsOld = Jobs ?? []
        jobsOld.append(jobFinish)
        Jobs = jobsOld
        performSegue(withIdentifier: "Unwind", sender: self)
    }
    func removeSpecialCharsFromString(text: String) -> String {
        let okayChars : Set<Character> =
            Set("$")
        return String(text.filter {okayChars.contains($0) })
    }

    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        JobPicker.delegate = self
        JobPicker.dataSource = self
        MoneyTxtField.addTarget(self, action: #selector(textFieldChanged(textField:)), for: .editingChanged)
    }
    
    func styleTextField(_ textfield:UITextField) {
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height * 0.65, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 90/255, green: 150/255, blue: 255/255, alpha: 1).cgColor
        
        bottomLine.cornerRadius = 1
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    func setupElements(){
        ErrorLabel.alpha = 0.0
        for btn in BtnCollection{
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = btn.frame.height / 5.0
        }
        WorkerNumPicker.selectedSegmentIndex = -1
        styleTextField(OtherTxtField)
        styleTextField(MoneyTxtField)
    }

}
extension JobSelectVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jobData.getJobAt(index: row).title
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 5{
            OtherStackView.isHidden = false
        }
        else{
            OtherStackView.isHidden = true
        }
        selectedJob = row
        setWorkerNumPicker(jobIndex: row)
    }
    
    func setWorkerNumPicker(jobIndex : Int){
        WorkerNumPicker.removeAllSegments()
        let reqSegments = WorkerNumPicker.numberOfSegments - jobData.getJobAt(index: jobIndex).maxPeople
            for _ in 1...abs(reqSegments){
                WorkerNumPicker.insertSegment(withTitle: String(WorkerNumPicker.numberOfSegments + 1), at: WorkerNumPicker.numberOfSegments, animated: false)
            }
        if WorkerNumPicker.numberOfSegments == 1 {
            WorkerNumPicker.selectedSegmentIndex = 0
            WorkerNumStackView.alpha = 0.5
        }
        else{
            WorkerNumPicker.selectedSegmentIndex = -1
            WorkerNumStackView.alpha = 1
        }
    }
    
    func showError(msg : String){
        ErrorLabel.text = msg
        ErrorLabel.alpha = 1.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? JobsVC ?? nil
        if destination != nil{
            destination!.loadData()
        }
    }
    
}

extension String {
    mutating func toArray() -> [String]{
        return Array(arrayLiteral: self)
    }
}
