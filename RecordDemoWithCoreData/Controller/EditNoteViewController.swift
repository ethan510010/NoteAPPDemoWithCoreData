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
    
    //toolbar
    @IBOutlet var toolbar: UIToolbar!
    //toolbar上面的按鈕動作
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        //開啟相機
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("The camera isn't able to turn on")
        }
    }
    
    @IBAction func findLocation(_ sender: UIBarButtonItem) {
    }
    
    //因為現在沒有真的使用CoreData所以先用delegate傳資訊到前一個畫面
    //    var delegate:SaveTitleAndContentDelegate?
    
    //接收前一個畫面傳過來的note
    var note:Note?
    
    //    var photoes:[Data] = [Data]()
    
    //photoes資料改變，此tableView就reloadData
    var photoes: [Photo] = [Photo](){
        didSet{
            DispatchQueue.main.async {
                self.photoTableView.reloadData()
            }
        }
    }
    
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
        
        //如果筆記已經存在，就更新資料；如果原本不存在則新存到CoreData中
        if self.note != nil{
            self.updateNote()
        }else{
            self.saveNote()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //選完照片後要做的事
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let size = CGSize(width: 320, height: image.size.height*320/image.size.width)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let imageData = UIImageJPEGRepresentation(resizeImage!, 0.8) else { return }
        //guard let imageData = UIImagePNGRepresentation(resizeImage!) else {return}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let photo = NSEntityDescription.insertNewObject(forEntityName:"Photo", into: context) as! Photo
        
        //
        
        photo.image = imageData as NSData
        //選完照片後給予照片號碼
        photo.number = Int16(self.photoes.count)
        self.photoes.append(photo)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTextField.delegate = self
        contentTextView.delegate = self
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        photoTableView.separatorStyle = .none
        
        self.contentTextView.text = self.note?.content
        self.topicTextField.text = self.note?.title
        
        if let photoSet = self.note?.noteImages{
            var photoArray = Array(photoSet) as! [Photo]
            //照片依號碼排序
            photoArray.sort { (photo1, photo2) -> Bool in
                return photo1.number < photo2.number
            }
            for eachPhotoData in photoArray{
                self.photoes.append(eachPhotoData)
            }
        }
        // Do any additional setup after loading the view.
        //把toolbar加到contentTextView的keyboard上
        contentTextView.inputAccessoryView = self.toolbar
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            //            var photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            //            note.addToNoteImages(photo)
            note.addToNoteImages(eachPhoto)
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
    
    //更新資料
    func updateNote(){
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagate.persistentContainer.viewContext
        
        if self.topicTextField.text != ""{
            //更新note裡面原先的屬性值
            note?.setValue(self.topicTextField.text, forKey: "title")
            note?.setValue(self.contentTextView.text, forKey: "content")
            for eachPhoto in self.photoes{
                note?.addToNoteImages(eachPhoto)
            }
        }
        do {
            try context.save()
        } catch  {
            print("update failed")
        }
    }
    
    //從CoreData取資料
    
    
}
extension EditNoteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! PhotoTableViewCell
        cell.selectionStyle = .none
        if let photoData = self.photoes[indexPath.row].image as? Data{
            cell.photoImageview.image = UIImage(data: photoData)
            //            print("image", cell.photoImageview.image)
        }
        //        cell.photoImageview.image = UIImage(data: photoes[indexPath.row] as! Data)
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
            context.delete(shouldDeleTePhoto)
            appDelegate.saveContext()
            //從tableview移除
            self.photoes.remove(at: indexPath.row)
        }
    }
    
}

extension EditNoteViewController: UITextViewDelegate, UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
}
