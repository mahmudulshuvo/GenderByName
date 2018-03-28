//
//  ViewController.swift
//  NamesML
//
//  Created by Brian Advent on 31.08.17.
//  Copyright © 2017 Brian Advent. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    var maleColor, femaleColor: UIColor!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        maleColor = UIColor(red: 78.0/255.0, green: 120.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        femaleColor = UIColor(red: 104.0/255.0, green: 34.0/255.0, blue: 139.0/255.0, alpha: 1.0)
        self.hideKeyboard()
        
    }
    
    // string="nina"
    /*  "firstLetter1=n"    :1.0    */
    /*  "firstLetter2=i"    :1.0    */
    /*  "firstLetter3=n"    :1.0    */
    /*  "lastLetter1=i"     :1.0    */
    /*  "lastLetter2=n"     :1.0   */
    /*  "lastLetter3=a"     :1.0    */
    
    func features (_ string:String) -> [String:Double] {
        guard !string.isEmpty else {return [:]}
        
        let string = string.lowercased()
        var keys = [String]()
        
        keys.append("firstLetter1=\(string.prefix(1))")
        keys.append("firstLetter2=\(string.prefix(2))")
        keys.append("firstLetter3=\(string.prefix(3))")
        keys.append("lastLetter1=\(string.suffix(1))")
        keys.append("lastLetter2=\(string.suffix(2))")
        keys.append("lastLetter3=\(string.suffix(3))")
        
        return keys.reduce([String: Double]()) { (result, key) -> [String: Double] in
            var result = result
            result[key] = 1.0
            
            return result
        }
        
    }
    
    func predictGenderFromName (_ name:String) -> String? {
        let nameFeatures = features(name)
        
        let model = GenderByName()
        
        if let prediction = try? model.prediction(input: nameFeatures) {
            if prediction.classLabel == "F" {
                return "Female"
            }else{
                return "Male"
            }
        }
        
        return nil
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        genderLabel.text = predictGenderFromName(textField.text!)
        if genderLabel.text == "Male" {
            self.view.backgroundColor = maleColor
            genderImage.image = UIImage(named: "male.png")
            
        }
        else {
            self.view.backgroundColor = femaleColor
            genderImage.image = UIImage(named: "female.png")
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

