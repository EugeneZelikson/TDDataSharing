//
//  ViewController.swift
//  TDDataSharingRecipient
//
//  Created by TopDevs on 7/10/18.
//  Copyright © 2018 TopDevs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let transfer = TDDataTransferManager(withRequestModel: TDRequestModel(withSourceURLScheme: "TDDataSharingRecipient",
                                                                          destinationURLScheme: "TDDataSharingReceiver"))
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        updateCounter()
    }
    
    // MARK: - Actions
    
    @IBAction func addImageAction(_ sender: Any) {
     
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)

    }
    
    @IBAction func addTextAction(_ sender: Any) {
        if let text = textField.text {
            transfer.payload.append(text)
        } else {
            shakeView(viewToShake: sender as! UIView)
        }
        updateCounter()
    }
    
    @IBAction func addDateAction(_ sender: Any) {
        transfer.payload.append(datePicker.date)
        updateCounter()
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
       
        transfer.sendPayload { [weak self] (success, error) in
            if (success == false) {
                guard let weakSelf = self else {
                    return
                }
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                weakSelf.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func undoAction(_ sender: Any) {
        
        if transfer.payload.count >= 1 {
            transfer.payload.removeLast()
        }
        updateCounter()
    }
    
    //MARK: - Private
    
    private func shakeView(viewToShake: UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    private func updateCounter() {
        counterLabel.text = "Counter: \(transfer.payload.count)"
        shakeView(viewToShake: counterLabel)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        transfer.payload.append(chosenImage)
        dismiss(animated:true, completion: nil)
        updateCounter()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
