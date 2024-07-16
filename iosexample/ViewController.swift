//
//  ViewController.swift
//  iosexample
//
//  Created by Rashmi Yadav on 24/11/22.
//

import UIKit
import CleverTapSDK

class ViewController: UIViewController, CleverTapInboxViewControllerDelegate, CleverTapDisplayUnitDelegate,UITextFieldDelegate {
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var identity: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    
    @IBOutlet weak var dob: UITextField!
    
    
    @IBOutlet weak var num: UITextField!
    
    
    @IBOutlet weak var userlogin: UIButton!
    
    @IBOutlet weak var pushprofile: UIButton!
    
    @IBOutlet weak var pushevent: UIButton!
    
    @IBOutlet weak var pusheventwithprops: UIButton!
    
    @IBOutlet weak var chargedevent: UIButton!
    
    @IBOutlet weak var appinbox: UIButton!
    
    @IBOutlet weak var nativedisplay: UIButton!
    
    @IBAction func nativedisplayfunc(_ sender: Any) {
        CleverTap.sharedInstance()?.recordEvent("Get Native Display")
        
    }
    @IBAction func userlogin(_ sender: UIButton) {
        // each of the below mentioned fields are optional
        // with the exception of one of Identity, Email, or FBID
        let _namefield: String? = name.text
        let _emailfield: String? = email.text
        let _idfield: String? = identity.text
        let _phonenum: String? = phone.text
     //   let : String? = dob.text
        let _numfield: Int? = Int(num.text!)
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let _dobfield = dateFormatter.date(from: dob.text!)
        
        let profile: Dictionary<String, Any> = [
            "Name": _namefield,       // String
            "Identity": _idfield,         // String or number
            "Email": _emailfield,    // Email address of the user
            "Phone": "+91"+_phonenum!,      // Phone (with the country code, starting with +)
            "Number":_numfield,
            // optional fields. controls whether the user will be sent email, push etc.
            "DOB":_dobfield,
            "MSG-email": false,           // Disable email notifications
            "MSG-push": true,             // Enable push notifications
            "MSG-sms": false,             // Disable SMS notifications
            "MSG-whatsapp": false,         // Enable WhatsApp notifications
        ]
        
        CleverTap.sharedInstance()?.onUserLogin(profile)
        var userDefaults = UserDefaults(suiteName: "group.nativeios")!
        userDefaults.set(_idfield, forKey:"identity" )
        userDefaults.set(_emailfield, forKey:"email" )
        userDefaults.synchronize()
    }
    @IBAction func pushProfile(_ sender: UIButton) {
        // each of the below mentioned fields are optional
        // if set, these populate demographic information in the Dashboard
        let _namefield: String? = name.text
        let _emailfield: String? = email.text
        let _idfield: String? = identity.text
        let _phonenum: String? = phone.text
        let _dobfield: String? = dob.text
        let _numfield: Int? = Int(num.text!)
        let dob = NSDateComponents()
              
                let d = NSCalendar.current.date(from: dob as DateComponents)
                let profile: Dictionary<String, Any> = [
                   
                    "Name": _namefield,       // String
                    "Identity": _idfield,         // String or number
                    "Email": _emailfield,    // Email address of the user
                    "Phone": "+91"+_phonenum!,      // Phone (with the country code, starting with +)
                    "Number":_numfield,
                    
                    "Employed": "Y" as AnyObject,                        // Can be either Y or N
                    "Education": "Graduate" as AnyObject,                // Can be either School, College or Graduate
                    "Married": "Y" as AnyObject,                         // Can be either Y or N
                    "DOB": d! as AnyObject,                              // Date of Birth. An NSDate object
                    "Age": 26 as AnyObject,                              // Not required if DOB is set
                    "Tz":"Asia/Kolkata" as AnyObject,                    //an abbreviation such as "PST", a full name such as "America/Los_Angeles",
                    //or a custom ID such as "GMT-8:00"
                    "Photo": "www.foobar.com/image.jpeg" as AnyObject,   // URL to the Image
                    
                    // optional fields. controls whether the user will be sent email, push etc.
                    "MSG-email": false as AnyObject,                     // Disable email notifications
                    "MSG-push": true as AnyObject,                       // Enable push notifications
                    "MSG-sms": false as AnyObject,                        // Disable SMS notifications
                    
                    //custom fields
                    "score": 15 as AnyObject,
                    "cost": 10.5 as AnyObject
                ]
                
                CleverTap.sharedInstance()?.profilePush(profile)

    }
    
    @IBAction func pushevent(_ sender: Any) {
        // event without properties
        CleverTap.sharedInstance()?.recordEvent("Test Event")
      
        
    }
    
    @IBAction func pusheventwithprops(_ sender: Any) {
        // event with properties
        let props = [
            "Product name": "Casio Chronograph Watch",
            "Category": "Mens Accessories",
            "Price": 59.99,
            "Date": NSDate()
        ] as [String : Any]

        CleverTap.sharedInstance()?.recordEvent("Test Event With Props", withProps: props)

        /**
         * Data types:
         * The value of a property can be of type NSDate, a Number, a String, or a Bool.
         *
         * NSDate object:
         * When a property value is of type NSDate, the date and time are both recorded to the second.
         * This can be later used for targeting scenarios.
         * For e.g. if you are recording the time of the flight as an event property,
         * you can send a message to the user just before their flight takes off.
         */
    }
    
    @IBAction func chargedevent(_ sender: UIButton) {
        let chargeDetails = [
            "Amount": 300,
            "Payment mode": "Credit Card",
            "Charged ID": 24052013
        ] as [String : Any]
        
        let item1 = [
            "Category": "books",
            "Book name": "The Millionaire next door",
            "Quantity": 1
        ] as [String : Any]
        
        let item2 = [
            "Category": "books",
            "Book name": "Achieving inner zen",
            "Quantity": 1
        ] as [String : Any]
        
        let item3 = [
            "Category": "books",
            "Book name": "Chuck it, let's do it",
            "Quantity": 5
        ] as [String : Any]
    
        CleverTap.sharedInstance()?.recordChargedEvent(withDetails: chargeDetails, andItems: [item1, item2, item3])
    }
    
    @IBAction func appinbox(_ sender: Any) {
       
        CleverTap.sharedInstance()?.registerInboxUpdatedBlock({
                   let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                   let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                   print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
               })
        
        let style = CleverTapInboxStyleConfig.init()
               style.title = "App Inbox"
               style.navigationTintColor = .black
               
               if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                   let navigationController = UINavigationController.init(rootViewController: inboxController)
                   self.present(navigationController, animated: true, completion: nil)
               }
    }
    override func viewDidLoad() {
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                   let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                   let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                   print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
               }))
        super.viewDidLoad()
        CleverTap.sharedInstance()?.setDisplayUnitDelegate(self);
        // Do any additional setup after loading the view.
        showDatePicker()
        
        name.delegate = self
        email.delegate = self
        identity.delegate = self
        phone.delegate = self
        dob.delegate = self
        num.delegate = self
    }

    func displayUnitsUpdated(_ displayUnits: [CleverTapDisplayUnit]) {
           // you will get display units here
        var units:[CleverTapDisplayUnit] = displayUnits;
        print("\n\n NATIVE DISPLAY:\n\n ",displayUnits[0].json as Any);
        print("\n\n Payload End \n\n")
      
        let showAlert = UIAlertController(title: "Native Display", message: "", preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))
   
        let imageData = NSData(contentsOf: NSURL(string: displayUnits[0].contents![0].mediaUrl!)! as URL)
     

        imageView.image =  UIImage(data: imageData as! Data) // Your image here...
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: "close", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            CleverTap.sharedInstance()?.recordDisplayUnitClickedEvent(forID: displayUnits[0].unitID!)
        }))
        self.present(showAlert, animated: true, completion: nil)
        CleverTap.sharedInstance()?.recordDisplayUnitViewedEvent(forID: displayUnits[0].unitID!)
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date

       //ToolBar
       let toolbar = UIToolbar();
       toolbar.sizeToFit()
       let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

     toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

      dob.inputAccessoryView = toolbar
      dob.inputView = datePicker

     }

      @objc func donedatePicker(){

       let formatter = DateFormatter()
       formatter.dateFormat = "dd/MM/yyyy"
       dob.text = formatter.string(from: datePicker.date)
       self.view.endEditing(true)
     }

     @objc func cancelDatePicker(){
        self.view.endEditing(true)
      }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
            return true
        }
    


}

