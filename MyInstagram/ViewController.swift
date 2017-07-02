//
//  ViewController.swift
//  SmartSave
//
//  Created by Yusuf Kelo on 6/4/17.
//  Copyright © 2017 Yusuf Kelo. All rights reserved.
//

import UIKit
import Parse;

class ViewController: UIViewController {
    var signUpModel=true;
    
    var activityIndicator = UIActivityIndicatorView();
    
    @IBOutlet weak var txtEmail: UITextField!

    
    @IBOutlet weak var riderOrDriver_outlet: UISwitch!
  
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var btnChangeSignUpMode_outlet: UIButton!
  
    
    @IBOutlet weak var rider_outlet: UILabel!
    
    
    @IBOutlet weak var driver_outlet: UILabel!
    
    @IBOutlet weak var btnSignupOrLogin: UIButton!
    
    var isDriver:Bool = false;

    @IBAction func riderOrDriver_switch(_ sender: Any) {
        
    
        
    }
    
    @IBAction func btnSignupOrLogin(_ sender: Any) {
        
        if txtEmail.text=="" || txtPassword.text==""{
            
            self.createAlert(title:"Error in form", message:"Please enter an email and password")
            
        }else {
            
            activityIndicator = UIActivityIndicatorView(frame:CGRect(x:0,y:0,width:50,height:50));
            activityIndicator.center = self.view.center;
            activityIndicator.hidesWhenStopped = true;
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray;
            view.addSubview(activityIndicator);
            activityIndicator.startAnimating();
            UIApplication.shared.beginIgnoringInteractionEvents();
            
            
            
            if signUpModel{
                let user = PFUser();
                user.username = txtEmail.text;
                user.email = txtEmail.text;
                user.password = txtPassword.text;
                user["isDriver"] = riderOrDriver_outlet.isOn;
                
                user.signUpInBackground(block: {(success,error) in
                    
                    self.activityIndicator.stopAnimating();
                    UIApplication.shared.endIgnoringInteractionEvents();
                    
                    
                    // print("--error:\(error)");
                    var signupError =  "Error occured while signining up user";
                    
                    if error != nil{
                        if let errorMessage = (error! as NSError).userInfo["error"] as? String{
                            signupError = errorMessage
                        }
                        
                        self.createAlert(title:"Unsucceful", message:signupError)
                        
                        
                    }else{
                        self.navigateToView();
                    }
                    
               
                    
                })
            }else{
                PFUser.logInWithUsername(inBackground:txtEmail.text!, password: txtPassword.text!, block: { (user, error) in
                    self.activityIndicator.stopAnimating();
                    UIApplication.shared.endIgnoringInteractionEvents();
                    //
                    if error != nil {
                        var errorMessage:String //= "Login failed";
                        
                        if let message = (error! as NSError).userInfo["error"] as? String{
                            
                            errorMessage = message;
                            self.createAlert(title:"Login Error", message: message)
                            
                        }
                        
                    }else{
                        print("logged in")
                        self.navigateToView()
                    }
                    //
                })
            }
        }
        

    }
    
    
    private func navigateToView(){
    if let isDriver = PFUser.current()?["isDriver"] as? Bool{
    
        if isDriver{
          self.performSegue(withIdentifier:"showDriver_segue",sender:self)
        }else {
    
            self.performSegue(withIdentifier:"showRider_segue",sender:self);
    
         }
       }
    }
    
 
    
    func createAlert(title:String,message:String){
        let  alert = UIAlertController(title:title,message:message,preferredStyle:UIAlertControllerStyle.alert);
        
        alert.addAction(UIAlertAction(title:"Ok",style:.default,handler:{(action) in
            
            self.dismiss(animated: true, completion: nil);
            
        }));
        
        self.present(alert,animated:true,completion:nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
             self.navigateToView()
        }
        
    }
    
    private func showSignupOptions(_ isSignup:Bool){
    
        rider_outlet.isHidden = isSignup;
        driver_outlet.isHidden = isSignup;
        riderOrDriver_outlet.isHidden = isSignup;
        signUpModel = !isSignup;
    
    }
    
    
    @IBAction func btnChangeSignUpMode(_ sender: Any) {
        
        if signUpModel{

            
            showSignupOptions(true);
            
            btnSignupOrLogin.setTitle("Login",for:[]);
            
            btnChangeSignUpMode_outlet.setTitle("Sign up",for:[]);
            
            //lblMessage.text="Dont have an account?"
            
        }else{
            showSignupOptions(true);
           
            btnSignupOrLogin.setTitle("Sign up",for:[]);
            
            btnChangeSignUpMode_outlet.setTitle("Login",for:[]);
            
           // lblMessage.text="Already have an account?";
            
            
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
               //hide navigation bar on login screen
               self.navigationController?.navigationBar.isHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

