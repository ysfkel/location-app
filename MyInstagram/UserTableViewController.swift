//
//  UserTableViewController.swift
//  MyInstagram
//
//  Created by Yusuf Kelo on 6/15/17.
//  Copyright © 2017 Yusuf Kelo. All rights reserved.
//

import UIKit
import Parse;

class UserTableViewController: UITableViewController {
    
    var usernames = [String]();
    var usersIDs = [String]();
    var isFollowing = ["" : true]//initializes a boolean array with string and boolean

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query();
        
        query?.findObjectsInBackground(block: { (objects,error) in
        
            
            if error != nil{
                if let err = error{
                    print(err);
                }
            }
            else if let users = objects{
                
                for object in users{
                    
                    if let user = object as? PFUser{
                        
                        //if user is not logged in user
                        if  user.objectId != PFUser.current()?.objectId{
                        
                        if let username = user.username{
                            
                             // create array from username
                             let name_components = username.components(separatedBy:"@");
                            
                              let name = name_components[0];
                            
                             self.usernames.append(name)
                            self.usersIDs.append(user.objectId!);
                            
                            let query = PFQuery(className:"Followers");
                            
                            query.whereKey("follower",equalTo:(PFUser.current()?.objectId)!)
                            query.whereKey("following",equalTo:user.objectId!);
                            
                            query.findObjectsInBackground(block: {(objects,error) in
                                
                                if let objects = objects {
                                    
                                    if objects.count > 0{
                                        
                                        self.isFollowing[user.objectId!] = true;
                                        
                                    }else{
                                        
                                        self.isFollowing[user.objectId!] = false;
                                        
                                    }
                                    
                                }
                                
                            })
                            
                            
                        }
                            
                        }
                        
                       
                        
                    }
                    
                }
                
            }
            
            self.tableView.reloadData();
            
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }

    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut();
        self.performSegue(withIdentifier:"showLogin",sender:self);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

         cell.textLabel?.text = usernames[indexPath.row];
        
           // if isFollowing[usersIDs[indexPath.row]]!{
                  cell.accessoryType = UITableViewCellAccessoryType.checkmark;
            //}
        
      

        return cell
    }
    
    //saves the following relationhp
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at:indexPath);
        
        
        if isFollowing[usersIDs[indexPath.row]]!{
            
            //set isFollowing to false cuz user is no more following
            isFollowing[usersIDs[indexPath.row]] = false;
            
            cell?.accessoryType =  UITableViewCellAccessoryType.none;
            
            let query = PFQuery(className:"Followers");
            
            query.whereKey("follower",equalTo:(PFUser.current()?.objectId!)!);
            query.whereKey("following",equalTo:usersIDs[indexPath.row]);
            
            query.findObjectsInBackground(block: { (objects,error) in
                
                if let objects = objects {
                     //loops - expected to be just 1 loop
                    //and deletes the relationship
                    for object in objects{
                        object.deleteInBackground();
                    }
                    
                }
                
            })
            
        }else{
            
           isFollowing[usersIDs[indexPath.row]] = true;
            
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark;
            
            let following = PFObject(className:"Followers");
            
            following["follower"] = PFUser.current()?.objectId;
            
            following["following"] = usersIDs[indexPath.row];
            
             following.saveInBackground();
            
        }
        
     
        
       
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
