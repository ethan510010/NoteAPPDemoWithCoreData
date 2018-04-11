//
//  EditNoteViewController.swift
//  RecordDemoWithCoreData
//
//  Created by EthanLin on 2018/4/10.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreData

//protocol SaveTitleAndContentDelegate {
//    func saveNote(title:String,content:String)
//}

class EditNoteViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //因為現在沒有真的使用CoreData所以先用delegate傳資訊到前一個畫面
//    var delegate:SaveTitleAndContentDelegate?
    
    //接收前一個畫面傳過來的
    var note:Note?
    
    var photoes:[Data] = [Data]()

    
    @IBOutlet weak var topicTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var photoTableView: UITableView!
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let topic = topicTextField.text, let content = contentTextView.text else {return}
//        delegate?.saveNote(title: topic, content: content)
        self.saveNote()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //選完照片後要做的事
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        guard let imageData = UIImagePNGRepresentation(image) else {return}
        self.photoes.append(imageData)
        self.photoTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        photoTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentTextView.text = self.note?.content
        self.topicTextField.text = self.note?.title
        
//        let photoArray = NSArray(array: (self.note?.noteImages)!)
        if let photoSet = self.note?.noteImages{
            let photoArray = Array(photoSet) as! [Photo]
            for eachPhotoData in photoArray{
                self.photoes.append(eachPhotoData.image! as Data)
            }
        }
    }
    
    
    //存筆記到CoreData
    func saveNote(){
        //筆記標題不可為空
        guard let topic = topicTextField.text, topic != "" else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //創建Managed Objects
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        //開始進行儲存
        //1. 存標題與內容
        note.title = topic
        guard let content = contentTextView.text, content != "" else { return }
        note.content = content
        //2. 存圖片
        for eachPhoto in self.photoes{
            var photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            photo.image = eachPhoto as NSData
            note.addToNoteImages(photo)
        }
        
        //存到coreData
        do {
            try context.save()
            print("save successfully")
            //存檔成功後
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(path)
            
        } catch  {
            print("Save to CoreData failed")
        }
    }
    
    //從coreData取資料
    
    
}
extension EditNoteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! PhotoTableViewCell
        cell.photoImageview.image = UIImage(data: photoes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * (150/667)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            //先從CoreData刪資料
            let shouldDeleTePhoto = self.photoes[indexPath.row]
            context.delete(<#T##object: NSManagedObject##NSManagedObject#>)
            //從tableview移除
            self.photoes.remove(at: indexPath.row)
            self.photoTableView.reloadData()
        }
    }
    
}
