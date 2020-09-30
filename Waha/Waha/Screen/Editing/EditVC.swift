//
//  EditVC.swift
//  Waha
//
//  Created by TaeHyeong Kim on 2020/09/12.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import Photos
import MediaPlayer
import PencilKit
import PhotosUI

class EditVC: UIViewController {
    
    //pencilKt
    @IBOutlet weak var canvasView: PKCanvasView!
    let canvasWidth: CGFloat = 768
    let canvasOverscrollHight: CGFloat = 500
    var drawing = PKDrawing()
    
    
    //View
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tmpImageView: UIImageView!
    
    var isNewVideo : Bool?
    var imageArray : [UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupProject()
        setupCanvasView()
        print("tableView image count : \(imageArray.count)")
        
    }
    private func setupProject(){
        setupTableView()
    }
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func setupCanvasView(){
        canvasView.delegate = self
        canvasView.drawing = drawing
        canvasView.alwaysBounceVertical = false
        canvasView.allowsFingerDrawing = false
        if let window = parent?.view.window,
           let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: canvasView)
            toolPicker.addObserver(canvasView)
            
            canvasView.becomeFirstResponder()
        }
        canvasView.isOpaque = false
        canvasView.backgroundColor = .clear
    }
   
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionExport(_ sender: Any) {
        saveDrawingToCameraRoll()
    }
    
    //hide home indicator for better performance
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    //rotating view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let canvasScale = canvasView.bounds.width/canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }
    private func updateContentSizeForDrawing(){
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        if drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHight) * canvasView.zoomScale)
        }else {
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }
    private func saveDrawingToCameraRoll(){
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: {success, error in
                //deal with success
            })
        }
    }
    
}
extension EditVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageFrameListTableViewCell", for: indexPath) as? ImageFrameListTableViewCell {
                cell.selectionStyle = .none
                cell.imageArray = imageArray
                cell.collectionView.reloadData()
                cell.delegate = self
                return cell
            }
        }else{
            let layer : [UIImage] = Array(repeating: UIImage(named: "overlay")!, count: imageArray.count)
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageFrameListTableViewCell", for: indexPath) as? ImageFrameListTableViewCell {
                cell.selectionStyle = .none
                cell.imageArray = layer
                cell.collectionView.reloadData()
                cell.delegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
extension EditVC : frameSelectDelegate {
    func selectedIndex(index: Int) {
        tmpImageView.image = imageArray[index]
    }
}
extension EditVC : PKCanvasViewDelegate, PKToolPickerObserver {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
//        updateContentSizeForDrawing()
    }
}
