//
//  PDFDisplayViewController.swift
//  PDFWithQLPreviewController
//
//  Created by Mr.LuDashi on 2017/7/5.
//  Copyright © 2017年 ZeluLi. All rights reserved.
//

import UIKit
import QuickLook

class PDFDisplayViewController: UIViewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource, URLSessionDownloadDelegate {
    
    var pdfURLPath: String!
    private var pdfLocationPath: String!
    private let pdfVC = QLPreviewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.addPDFDisplayVC()
        
        if pdfURLPath != nil {
            self.downloadPdfFile(urlString: pdfURLPath)
        }
    }
    
    func addPDFDisplayVC() {
        pdfVC.dataSource = self
        pdfVC.delegate = self
        pdfVC.view.frame = self.view.bounds
        self.addChildViewController(pdfVC)
        self.view.addSubview(pdfVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        if pdfLocationPath != nil {
            return 1
        }
        return 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if pdfLocationPath != nil {
            return NSURL(fileURLWithPath: pdfLocationPath) as QLPreviewItem
        }
        
        return NSURL(fileURLWithPath: self.pdfURLPath) as QLPreviewItem
    }
    
    func downloadPdfFile(urlString: String) {
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: URL(string: urlString)!)
        downloadTask.resume()
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        

        let newFilePath = NSHomeDirectory() + "/Documents/xinghuo.pdf"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: newFilePath) {
            try? fileManager.removeItem(atPath: newFilePath)
        }
        try? fileManager.moveItem(atPath: location.path, toPath: newFilePath)
        
        
        
        
        
        pdfLocationPath = newFilePath
        print(newFilePath)
        DispatchQueue.main.async {
            self.pdfVC.reloadData()
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(bytesWritten)
        print(totalBytesWritten)
        print(totalBytesExpectedToWrite)
        print("")
    }
    
    
}
