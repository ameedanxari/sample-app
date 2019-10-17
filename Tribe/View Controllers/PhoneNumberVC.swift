//
//  PhoneNumberVC.swift
//  Tribe Technology Ventures
//
//  Created by macintosh
//  Copyright © 2017 Tribe Technology Ventures. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhoneNumberVC: UIViewController, MICountryPickerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var vwPhoneNumber: UIView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var btnCountryCode: UIButton!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    let picker = MICountryPicker()
    var countryCode: String!
    // MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        vwPhoneNumber.layer.borderWidth = 1
        vwPhoneNumber.layer.cornerRadius = 10
        vwPhoneNumber.layer.borderColor = UIColor.tribe_theme_orange.cgColor
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            btnCountryCode.setTitle("+" + getCountryCallingCode(countryRegionCode: countryCode), for: .normal)
        }
        
        // delegate
        picker.delegate = self
        txtPhoneNumber.delegate = self
        // Optionally, set this to display the country calling codes after the names
        picker.showCallingCodes = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /**
     Overriding touch event delegate to dismiss keyboard when tapped anywhere on the screen outside the textfield.
     
     - Parameter touches:   Set containing touch points.
     - Parameter event:   Event triggered by the touch.
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   // MARK: - Actions
    /**
     Shows the view controller with list of country codes.
     
     - Parameter sender:   UIButton triggering the action.
     */
    @IBAction func btncountryCodeAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(picker, animated: true)
    }
    
    /**
     Checks if a valid phone number is entered and takes the user to verfication code view controller to verify phone number.
     
     - Parameter sender:   UIButton triggering the action.
     */
    @IBAction func btnContinueAction(_ sender: UIButton) {
        if txtPhoneNumber.text! == ""
        {
            UtilManager.showAlertMessage(message: "Please enter your phone number")
        }
        else
        {
            var number = txtPhoneNumber.text!
            if number.hasPrefix("0")
            {
                number.remove(at: number.startIndex)
            }
            
            Global.user.phoneNumber = (btnCountryCode.titleLabel?.text!)! + number.replacingOccurrences(of: "-", with: "")
            let alert = UIAlertController(title: "Phone Number", message: "Is this your Phone Number \n \(Global.user.phoneNumber!)", preferredStyle: .actionSheet)
            
            let action = UIAlertAction(title: "Yes", style: .default, handler:
            {
                
                (alert: UIAlertAction!) -> Void in
                UtilManager.showGlobalProgressHUDWithTitle("Please Wait..."); PhoneAuthProvider.provider().verifyPhoneNumber("\(Global.user.phoneNumber!)") {(verificationID,error) in
                    
                    if error != nil
                    {
                        UtilManager.dismissGlobalHUD()
                        UtilManager.showAlertMessage(message: String(describing: error!.localizedDescription))
                        print ("Error: \(String(describing: error?.localizedDescription))")
                    }
                    else
                    {
                        UtilManager.dismissGlobalHUD()
                        let defaults = UserDefaults.standard
                        defaults.setValue(verificationID, forKey: "authID")
                        
                        let verifyPhoneNumberVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneNumberVC") as! VerifyPhoneNumberVC
                        
                        self.navigationController?.pushViewController(verifyPhoneNumberVC, animated: true)
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
            })
            alert.addAction(action)
            
            alert.addAction(cancelAction)
            
            if let popoverController = alert.popoverPresentationController { // for ipads
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midX, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    /**
     Translates the two-letter region code to country dialing code prefix.
     
     - Parameter countryRegionCode:   Two-letter region code that needs to be converted to dailing code.
     
     - Returns: Dialing code prefix for the region. Returns empty string if not found
     */
    func getCountryCallingCode(countryRegionCode:String) -> String {
        
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        let countryDialingCode = prefixCodes[countryRegionCode.uppercased()]
        return countryDialingCode ?? ""
        
    }
    
    /**
     Delegate method called when the user has selected country in MICountryPicker.
     
     - Parameter picker:   MICountryPicker triggering the event.
     - Parameter name:   Name of the country selected.
     - Parameter code:   Two-letter region code of the country selected.
     - Parameter dialCode:   Dialing code for the country selected.
     */
    func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        countryCode = dialCode
        btnCountryCode.setTitle(dialCode, for: .normal)
    }
    
    /**
     Delegate method called when the user has selected country in MICountryPicker.
     
     - Parameter picker:   MICountryPicker triggering the event.
     - Parameter name:   Name of the country selected.
     - Parameter code:   Two-letter region code of the country selected.
     */
    func countryPicker(picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        print(name)
    }
    
    // MARK: - UITextField Delegate Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var groupSize = 3
        let separator = "-"
        if string.count == 0 {
            groupSize = 4
        }
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.groupingSize = groupSize
        formatter.usesGroupingSeparator = true
        formatter.secondaryGroupingSize = 3
        if var number = textField.text, string != "" {
            number = number.replacingOccurrences(of: separator, with: "")
            if let doubleVal = Double(number) {
                let requiredString = formatter.string(from: NSNumber.init(value: doubleVal))
                textField.text = requiredString
            }
            
        }
        return true
    }
}
