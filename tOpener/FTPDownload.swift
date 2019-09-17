//
//  FTPDownload.swift
//  VisualHTMLeditor
//
//  Created by Valeriy PETRENKO on 06/05/2018.
//  Copyright © 2018 Slavamax BVBA. All rights reserved.
//

import Foundation
import CFNetwork

public class FTPDownload {
    var bytesRead = 0
    fileprivate let ftpBaseUrl: String
    fileprivate let directoryPath: String
    fileprivate let username: String
    fileprivate let password: String
    
    public init(baseUrl: String, userName: String, password: String, directoryPath: String) {
        self.ftpBaseUrl = baseUrl
        self.username = userName
        self.password = password
        self.directoryPath = directoryPath
    }
}


// MARK: - Steam Setup
extension FTPDownload {
    private func setFtpUserName(for ftpReadStream: CFReadStream, userName: CFString) {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPUserName)
        CFReadStreamSetProperty(ftpReadStream, propertyKey, userName)
    }
    
    private func setFtpPassword(for ftpReadStream: CFReadStream, password: CFString) {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPPassword)
        CFReadStreamSetProperty(ftpReadStream, propertyKey, password)
    }
    
    fileprivate func ftpReadStream(forFileName fileName: String) -> CFReadStream? {
        let fullyQualifiedPath = "ftp://\(ftpBaseUrl)/\(directoryPath)/\(fileName)"
        
        guard let ftpUrl = CFURLCreateWithString(kCFAllocatorDefault, fullyQualifiedPath as CFString, nil) else { return nil }
        let ftpStream = CFReadStreamCreateWithFTPURL(kCFAllocatorDefault, ftpUrl)
        let ftpReadStream = ftpStream.takeRetainedValue()
        setFtpUserName(for: ftpReadStream, userName: username as CFString)
        setFtpPassword(for: ftpReadStream, password: password as CFString)
        return ftpReadStream
    }
}


// MARK: - FTP Read
extension FTPDownload {
    public func send(data: Data, with fileName: String, success: @escaping ((Bool)->Void)) {
        // ftpup.send(data: filedata, with: self.currentFileName, success: {(success) 
        //"ftp://ordodei:#Flopopo1965@ftp.slavamax.com/index.html"
        
        guard let ftpReadStream = ftpReadStream(forFileName: fileName) else {
                //print("error ftpReadStream(forFileName: fileName)=\(fileName)")
            success(false)
            return
        }
        
        if CFReadStreamOpen(ftpReadStream) == false {
            //print("Could not open stream")
            success(false)
            return
        }
        
        let fileSize = data.count
           let bufSize = 4096 // 1024
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
        data.copyBytes(to: buffer, count: fileSize)
        
        /*
        defer {
            CFReadStreamClose(ftpReadStream)
            buffer.deallocate(capacity: fileSize)
        }
        */
      //  var offset: Int = 0
        var dataToReadSize: Int = 0
    // var bytesRead = 0
        
         guard let data = NSMutableData(capacity: bufSize) else { return  }
      
        
        var shouldContinue = true
        repeat {
            let streamStatus = CFReadStreamGetStatus(ftpReadStream)
           ////print("streamStatus=\(streamStatus)")
           // let enumName = String(describing: streamStatus.self)
            //print("enumName=\(enumName)")
            
            
            switch streamStatus {
            case .opening:
                //print(" The stream is being opened for reading or for writing.")
                 break
            case .writing:
                //print("  The stream is being written to.")
                 break
            case .error:
                //print("  An error occurred on the stream.")
                shouldContinue = false
                success(false)
                return
            case .notOpen:
                //print(" notOpen")
                 break
            case .reading:
                //print(" reading")
                 break
            case .atEnd:
                //print(" atEnd")
                 break
            case .closed:
                //print(" closed")
                 break
            case .open:
                //print(" open")
                 break
            }
            
            
            if  (CFReadStreamHasBytesAvailable(ftpReadStream)) {
                 bytesRead = CFReadStreamRead(ftpReadStream, buffer, bufSize)
                //print("ftp bytes written: \(bytesRead)")
              
                if bytesRead > 0 {
                    data.append(buffer, length: bytesRead)
                    
                    //offset += bytesRead.littleEndian
                    dataToReadSize += bytesRead
                     //print("ftp bytes written: \(bytesRead)")
                    continue
                } else if bytesRead < 0 {
                    // ERROR
                    //print("FTP Upload - ERROR")
                    shouldContinue = false
                    success(false)
                    return
                   
                } else if bytesRead == 0 {
                    // SUCCESS
                    //print("FTPUpload - Completed!!")
                    shouldContinue = false
                    break
                }
            } // else {
              //  usleep(200000)
                ////print(".", separator: "", terminator: "")
           // }
        } while shouldContinue
        
       // let string = String(data: data as Data, encoding: String.Encoding.utf8)
        //print("* downloaded *")
       // //print(string ?? "")
        
        
        
        
        success(true)
       
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let destinationUrl = documentsUrl.appendingPathComponent(fileName)
         if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
        {
            #if DEBUG
            //print("  line \(#line)   ")
            #endif
          }
        
    }
}
