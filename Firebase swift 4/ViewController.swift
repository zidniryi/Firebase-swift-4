//
//  ViewController.swift
//  Firebase swift 4
//
//  Created by hint on 24/08/18.
//  Copyright © 2018 ZidniRyi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    
//    Deklarasi dari variabel database
    var ref: DatabaseReference!
    
//    Dari File |Deklarasi Globa
    var dataUser = [Users]()

    @IBOutlet weak var etName: UITextField!
    @IBOutlet weak var etAdress: UITextField!
    
    @IBOutlet weak var showTable: UITableView!
    

    @IBOutlet weak var banner2: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        banner2.adUnitID = "ca-app-pub-2324785827276958/4947732590"
        banner2.rootViewController = self
        
        ref = Database.database().reference().child("Zidniryi")
        // Do any additional setup after loading the view, typically from a nib.
        getData()
    }
//Fungsi buat nampilin datatable ======
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = dataUser[indexPath.row].name
        cell?.detailTextLabel?.text = dataUser[indexPath.row].adress
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataUser.count
    }
//    =============
    
    @IBAction func btnAction(_ sender: Any) {
//        Membuat key pengganti dari ID kalau pakai MYSQL, update berdasarkan Key nya
        let key = ref.childByAutoId().key
        
        let params = ["name" : etName.text, "adress" : etAdress.text]
        
//        Save to database firebase
        ref.child(key).setValue(params)
        
    }
    
    func getData(){
        ref.observe(DataEventType.value, with: { (snapshot) in
//            Cek todo 2 Looping firebasenya kosong apa gak
            
            if snapshot.childrenCount > 0{
//                Biar gak numpuk
                self.dataUser.removeAll()
                
//                Looping dari data firebase
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let datas = data.value as? [String : AnyObject]
                    let name = datas!["name"]
                    let adress = datas!["adress"]
                    
                    let user = Users(name: name as! String, adress: adress as! String, key: data.key)
                    
                    self.dataUser.append(user)
                    
                    self.showTable.reloadData()
                }
                
            }
          
            
            
           // let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            // ...
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

