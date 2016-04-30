//
//  ViewController.swift
//  Meme-1.0-Patel
//
//  Created by Harshal Patel on 4/24/16.
//  Copyright © 2016 Harshal Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    let textDelegate = TextBoxDelegate()

    @IBOutlet weak var ImageViewOutlet: UIImageView!
    @IBOutlet weak var UseCameraOutlet: UIBarButtonItem!
    @IBOutlet weak var ToolBarOutlet: UIToolbar!

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
    ]
    
    struct savedMeme {
        var TopText: String
        var BottomText: String
        var imageOnly: UIImage
        var memeImage: UIImage
    }

    func generateMemedImage() -> UIImage {
        ToolBarOutlet.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        ToolBarOutlet.hidden = false
        
        return memedImage
    }
    
    @IBAction func ShareMemeAction(sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
                let meme = savedMeme(TopText: self.TopBoxOutlet.text!, BottomText: self.BottomBoxOutlet.text!, imageOnly: self.ImageViewOutlet.image!, memeImage: self.generateMemedImage())
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TopBoxOutlet.delegate = textDelegate
        self.BottomBoxOutlet.delegate = textDelegate
        
        self.TopBoxOutlet.placeholder = "Top"
        self.BottomBoxOutlet.placeholder = "Bottom"
        
        self.TopBoxOutlet.textAlignment = .Center
        self.BottomBoxOutlet.textAlignment = .Center
        
        self.TopBoxOutlet.defaultTextAttributes = memeTextAttributes
        self.BottomBoxOutlet.defaultTextAttributes = memeTextAttributes
        
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat  {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(self.BottomBoxOutlet.editing)    {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotification()  {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil )
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification()    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UseCameraOutlet.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotification()
    }

    @IBAction func useCameraAction(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.delegate = self
        
        self.presentViewController(pickerController, animated: false, completion: nil)
    }
    
    @IBOutlet weak var BottomBoxOutlet: UITextField!
    @IBOutlet weak var TopBoxOutlet: UITextField!
    
    @IBAction func pickImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        
        pickerController.delegate = self
        
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageViewOutlet.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)  {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

