//
//  ViewController.swift
//  TestePromobit
//
//  Created by Bruna Fernanda Drago on 14/10/20.
//

import UIKit
import Alamofire
import SDWebImage

class ContactVC : UIViewController {
    
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    @IBOutlet weak var msgPlaceholder: UILabel!
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var contacts : [ContactData] = []
    let placeholder = UIImage(named: "avatar")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewPlaceholder.isHidden = true
        
        callGetContacts()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        contactTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        makeButtonRound()

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let backItem = UIBarButtonItem()
     backItem.title = " "
     navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "goToAdd"{
            let vc = (segue.destination as? AddContactVC)
            vc?.list = contacts
            
        } else if segue.identifier == "goToFilter" {
            let vc = (segue.destination as? FilterVC)
            vc?.filterInfo = contacts
        }
    }

    func makeButtonRound(){
        addButton.layer.cornerRadius = addButton.frame.size.width / 2
        addButton.layer.masksToBounds = true
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        
    }
    
    func callGetContacts(){
        ServiceManager.shared.getContacts { (contacts, errorMsg) in
            guard let contacts = contacts else {
                print("erro na call")
               // self.viewPlaceholder.isHidden = false
                return
            }
            self.contacts = contacts
            print(contacts)
            DispatchQueue.main.async {
                self.contactTableView.reloadData()
            }
        }
    }


}
extension ContactVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contactTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ContactCell
        cell.companyLbl.text = contacts[indexPath.row].userCompany
        let name = contacts[indexPath.row].userName
        let lastname = contacts[indexPath.row].userLastname
        cell.nameLbl.text = "\(name)" + " " + "\(lastname)"
        let responseURL = contacts[indexPath.row].userPhoto
        let imageURL = URL(string: responseURL)
      
        cell.userPhoto.sd_setImage(with: imageURL, placeholderImage: placeholder)
        let isNew = contacts[indexPath.row].userNovo
        if isNew == false{
           
            cell.isNewView.isHidden = true
        }else {
           
            cell.isNewView.isHidden = false
        }
        
        return cell
    }
    
    
}

