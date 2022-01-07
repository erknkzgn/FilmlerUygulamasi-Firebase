//
//  ViewController.swift
//  FilmlerUygulamasi
//
//  Created by Kasım Adalan on 30.07.2019.
//  Copyright © 2019 info. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var kategoriTableView: UITableView!
    
    var kategorilerListe = [Kategoriler]()
    var ref:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kategoriTableView.delegate = self
        kategoriTableView.dataSource = self
        
        ref = Database.database().reference()
        tumKategorilerAl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilm"
        {
            let index = sender as! Int
            let gidilecekVC = segue.destination as! FilmViewController
            gidilecekVC.kategori = kategorilerListe[index]
        }
    }
    
    func tumKategorilerAl(){
        
        ref.child("kategoriler").observe(.value, with: {
            snapshot in
            if let gelenveri = snapshot.value as? [String:AnyObject]
            {
                self.kategorilerListe.removeAll()
                for gelensatırverisi in gelenveri
                {
                    if let sozluk = gelensatırverisi.value as? NSDictionary
                    {
                        let key              = gelensatırverisi.key
                        let kategori_ad      = sozluk["kategori_ad"] as? String ?? ""
                        
                        let kategori = Kategoriler(kategori_id: key, kategori_ad: kategori_ad)
                        
                        self.kategorilerListe.append(kategori)
                    }
                }
                DispatchQueue.main.async {
                    self.kategoriTableView.reloadData()
                }
            }
        })
        
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategorilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kategori = kategorilerListe[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kategoriHucre", for: indexPath) as! KategoriHucreTableViewCell
        
        cell.labelKategoriAd.text = kategori.kategori_ad
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toFilm", sender: indexPath.row)
    }
}
