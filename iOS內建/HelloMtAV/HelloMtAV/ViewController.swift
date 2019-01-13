//
//  ViewController.swift
//  HelloMtAV
//
//  Created by user37 on 2018/2/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit //For AVPlayerViewController
import MobileCoreServices
import Photos
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
    @IBOutlet weak var sourcetypeSegment: UISegmentedControl!
    @IBOutlet weak var resultImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //取得授權
        PHPhotoLibrary.requestAuthorization { (status) in
            print("PHPhotoLibrary auth status: \(status)")
        }
    }
    @IBAction func playRemoteMp4(_ sender: UIButton) {
        //HTTP live Streaming. (HLS) 內建
        //RTSP/RTMP
        guard let url = URL.init(string: "http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8") else {
            return
        }
        playWith(url)
    }
    @IBAction func playLocalMp4(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "the-smartest-smartphone.mp4", withExtension: nil) else {
            return
        }
        playWith(url)
    }
    @IBAction func playRemoteMp3(_ sender: UIButton) {
    }
    @IBAction func stop(_ sender: Any) {
        player?.rate = 0.0
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    @IBAction func thumbnail(_ sender: UIButton) {
        guard let url = Bundle.main.url(forResource: "the-smartest-smartphone.mp4", withExtension: nil) else {
            return
        }
        let asset = AVAsset.init(url: url)
        let generator = AVAssetImageGenerator.init(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMake(150, 30)
        let imageRef = try? generator.copyCGImage(at: time, actualTime: nil)
        if let imageRef = imageRef {
            let image = UIImage.init(cgImage: imageRef)
            resultImageView.image = image
        }
    }
    @IBAction func takePicture(_ sender: Any) {
        let imgPickerSourceType:UIImagePickerControllerSourceType
        switch sourcetypeSegment.selectedSegmentIndex{
        case 0:
            imgPickerSourceType = .photoLibrary
        case 1:
            imgPickerSourceType = .camera
        default:
            assertionFailure("never here")//通知crash
            return
        }
        guard UIImagePickerController.isSourceTypeAvailable(imgPickerSourceType) else {
            print("Source Type is not available")
            return
        }
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = imgPickerSourceType
        imgPicker.mediaTypes = ["public.image","public.movie"]//or [kUTTypeImage,kUTTypeMovie]
        imgPicker.delegate = self
        if imgPickerSourceType == .camera {
            imgPicker.showsCameraControls = false
            let takeBtn = UIButton.init(type: .roundedRect)
            takeBtn.setTitle("take photo", for: .normal)
            takeBtn.addTarget(imgPicker, action: #selector(UIImagePickerController.takePicture), for: .touchUpInside)
            takeBtn.frame = CGRect.init(x: 20, y: 20, width: 80, height: 30)
            imgPicker.cameraOverlayView?.addSubview(takeBtn)
        }
        present(imgPicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let type = info[UIImagePickerControllerMediaType] as? String else {
            assertionFailure()
            return
        }
        print("didFinishPickingMediaWithInfo: \(info)")
        if type == (kUTTypeImage as String) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let resizedImage = originalImage.resize(maxWidthHeight: 1024)
            guard let modifiedImage = modifyWith(resizedImage) else {
                return
            }
            resultImageView.image = modifiedImage
            saveImage(modifiedImage)
//            let data1 = UIImageJPEGRepresentation(resizedImage, 0.1)
//            let data2 = UIImagePNGRepresentation(resizedImage)
        } else if type == (kUTTypeMovie as String){
            guard let url = info[UIImagePickerControllerMediaURL] as? URL else {
                return
            }
            playWith(url)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(_ image:UIImage) {
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success {
                print("save OK")
            } else if let err = error{
                print("error:\(err)")
            }
        }
    }
    func modifyWith(_ image:UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        UIGraphicsBeginImageContext(image.size)
        let frameImage = UIImage.init(named: "frame_01.png")
        let rec = CGRect.init(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rec)
        frameImage?.draw(in: rec)
        let text = "嘻嘻\u{1F4A9}\u{1F4A9}\u{1F4A9}\u{1F4A9}\u{1F4A9}\u{1F4A9}\u{1F4A9}\u{1F4A9}" as NSString
        let color = UIColor.purple
        let font = UIFont.systemFont(ofSize: 80)
        let attribute:[NSAttributedStringKey:Any] = [.font:font,.foregroundColor:color]
        let textSize = text.size(withAttributes: attribute)
        let yOffset = (image.size.height - textSize.height) / 2
        text.draw(at: CGPoint.init(x: 0, y: yOffset), withAttributes: attribute)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    func playWith(_ url:URL){
        if player != nil {
            stop(self)
        }
//        let item = AVPlayerItem.init(url: url)
//        player = AVPlayer.init(playerItem: item)
        player = AVPlayer.init(url: url)
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer?.frame = resultImageView.frame
        if let layer = playerLayer {
            self.view.layer.addSublayer(layer)
        }
        player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFullScreen" {
            stop(self)
            guard let url = URL.init(string: "http://184.72.239.149/vod/smil:bigbuckbunnyiphone.smil/playlist.m3u8") else {
                return
            }
            guard let playerVC = segue.destination as? AVPlayerViewController else {
                return
            }
            playerVC.player = AVPlayer.init(url: url)
            playerVC.player?.play()
        }
    }

}

