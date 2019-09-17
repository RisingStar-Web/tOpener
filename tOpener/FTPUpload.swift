
import Foundation
import CFNetwork

public class FTPUpload {
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
extension FTPUpload {
    private func setFtpUserName(for ftpWriteStream: CFWriteStream, userName: CFString) {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPUserName)
        CFWriteStreamSetProperty(ftpWriteStream, propertyKey, userName)
    }

    private func setFtpPassword(for ftpWriteStream: CFWriteStream, password: CFString) {
        let propertyKey = CFStreamPropertyKey(rawValue: kCFStreamPropertyFTPPassword)
        CFWriteStreamSetProperty(ftpWriteStream, propertyKey, password)
    }

    fileprivate func ftpWriteStream(forFileName fileName: String) -> CFWriteStream? {
        let fullyQualifiedPath = "ftp://\(ftpBaseUrl)/\(directoryPath)/\(fileName)"

        guard let ftpUrl = CFURLCreateWithString(kCFAllocatorDefault, fullyQualifiedPath as CFString, nil) else { return nil }
        let ftpStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, ftpUrl)
        let ftpWriteStream = ftpStream.takeRetainedValue()
        setFtpUserName(for: ftpWriteStream, userName: username as CFString)
        setFtpPassword(for: ftpWriteStream, password: password as CFString)
        return ftpWriteStream
    }
}


// MARK: - FTP Write
extension FTPUpload {
    public func send(data: Data, with fileName: String, success: @escaping ((Bool)->Void)) {

        guard let ftpWriteStream = ftpWriteStream(forFileName: fileName) else {
            success(false)
            return
        }

        if CFWriteStreamOpen(ftpWriteStream) == false {
            //print("Could not open stream")
            success(false)
            return
        }

        let fileSize = data.count
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: fileSize)
        data.copyBytes(to: buffer, count: fileSize)

        defer {
            CFWriteStreamClose(ftpWriteStream)
            buffer.deallocate(capacity: fileSize)
        }

        var offset: Int = 0
        var dataToSendSize: Int = fileSize
        
        var shouldContinue = true
        repeat {
            let streamStatus = CFWriteStreamGetStatus(ftpWriteStream)
             //print("streamStatus=\(streamStatus)")
           //let enumName = String(describing: streamStatus.self)
              //print("enumName=\(enumName)")
            
         
            switch streamStatus {
            case .opening:
                 //print(" The stream is being opened for reading or for writing.")
                 break
            case .writing:
                 //print("  The stream is being written to.")
                 break
            case .error:
                  shouldContinue = false
                    success(false)
                 //print("  An error occurred on the stream.")
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
            
            
            if (CFWriteStreamCanAcceptBytes(ftpWriteStream)) {
                let bytesWritten = CFWriteStreamWrite(ftpWriteStream, &buffer[offset], dataToSendSize)
                //print("ftp bytes written: \(bytesWritten)")
                if bytesWritten > 0 {
                    offset += bytesWritten.littleEndian
                    dataToSendSize -= bytesWritten
                    continue
                } else if bytesWritten < 0 {
                    // ERROR
                    //print("FTP Upload - ERROR")
                       shouldContinue = false
                    break
                } else if bytesWritten == 0 {
                    // SUCCESS
                    //print("FTPUpload - Completed!!")
                    shouldContinue = false
                    break
                }
            } else {
                usleep(200000)
                ////print(".", separator: "", terminator: "")
            }
        } while shouldContinue
        
        success(true)
        
    }
}
