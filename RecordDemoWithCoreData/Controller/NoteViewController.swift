//
//  ViewController.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/4/10.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController /* SaveTitleAndContentDelegate */  {
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var noteArray:[Note] = [Note]()
    
//    //delegate的方法
//    func saveNote(title: String, content: String) {
//        noteTitleArray.append(title)
//        self.categoryTableView.reloadData()
//    }
    
 
    
    @IBAction func goEditVCAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goEditVC", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goEditVC"{
//            guard let editVC = segue.destination as? EditNoteViewController else {return}
//            editVC.delegate = self
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 0.5)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //提取CoreData的數據
        fetchNote()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //提取CoreData的數據
    func fetchNote(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            self.noteArray = try context.fetch(Note.fetchRequest())
        } catch  {
            print("FetchNoteError")
        }
        self.categoryTableView.reloadData()
    }
}
extension NoteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = noteArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if editingStyle == .delete{
            //刪除CoreData資料庫的
            let shouldDeleteNote = self.noteArray[indexPath.row]
            context.delete(shouldDeleteNote)
            appDelegate.saveContext()
            //刪除tableView的
            self.noteArray.remove(at: indexPath.row)
            //重新整理tableView
            self.categoryTableView.reloadData()
        }
    }
    
    //可以讓現在沒有tableView的部分，被footer的View蓋住，原理是寫上一個ViewForFooter等於一個section的完成，但因為我們只讓tableView顯示一個section，所以其它自然了就不會出現
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
//        view.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 0.5)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goEditVC", sender: self.noteArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goEditVC"{
            if let editVC = segue.destination as? EditNoteViewController{
                if let selectedNote = sender as? Note{
                    editVC.note = selectedNote
                }
            }
        }
    }
    
}
