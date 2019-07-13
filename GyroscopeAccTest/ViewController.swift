//
//  ViewController.swift
//  GyroscopeAccTest
//
//  Created by Steven on 7/9/19.
//  Copyright © 2019 Steven. All rights reserved.
//

import UIKit
import CoreMotion

struct DataModel{
    var acceleration: (x: String,y: String,z: String)
    var gravity: (x: String,y: String,z: String)
    var timeLog: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var fileAmount: UILabel!
    let manager = FileManager.default

    var getData : [DataModel] = []
    
    @IBOutlet weak var artLbl: UILabel!
    
    @IBOutlet weak var stepLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    var motionManager = CMMotionManager()
    
    var artSet = "heart"
    
    var savedFile: Int = 1
    
    var step: Int = 0
    
    var artFLag: Int = 0
    
    var isFlag = false
    
    var stepTimer : [[Int]] = [[7,10],[6,13]]
    
    var time: Int = 0
    
    var timerShow: Timer?
  
    var textData :UITextField?
    
    var getUserName: String = ""
    
    var fileTotal : Int = 0
    
    var typeData: [String] = ["acceleration","gravity","timelog"]
    
    var getPath: [URL] = []
    
    @IBAction func recordData(_ sender: Any) {
        // cri cara buat jalanin timer
        
        StartRecordData()
       timerShow = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSet), userInfo: nil, repeats: true)
        
    }
    
    func getFilePath(){
        let document = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        //let pathComponent =
        
        let targetDir: URL = document!
        
        getPath = try! manager.contentsOfDirectory(at: targetDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    }
    
    @IBAction func shareFIle(_ sender: Any) {
        
 
        fileAmount.text = "\(getPath.count)"
    
        if getPath != [] {
            fileTotal = getPath.count - 1
            do {
                let text2 = try String(contentsOf: getPath[fileTotal], encoding: .utf8)
                print(text2)
            }
            catch {/* error handling here */}
            let activityViewController = UIActivityViewController(activityItems: ["File 1",getPath[fileTotal]], applicationActivities: nil)
            
            present(activityViewController,animated: true,completion: nil)
            
            getPath.remove(at: getPath.count-1)
        }
        
        
    }
    
    
    @objc func timerSet(_ timer:Timer){
        
        
        if time > 0 {
            time -= 1
            
        }else{
            timer.invalidate()
            self.timerShow = nil
            StopRecordData()
            time = stepTimer[artFLag][step]
            timeLbl.text = "\(time)"
        }
        timeLbl.text = "\(time)"
    }
    
    @IBAction func restartData(_ sender: Any) {
        getData = []
        time = stepTimer[artFLag][step]
        timeLbl.text = "\(time)"
        
        
//        getFilePath()
//        for i in 0...getPath.count-1 {
//            try! manager.removeItem(at: getPath[i])
//        }
        
        
    }
    
    @IBAction func saveData(_ sender: Any) {
        //save format ke file
//        artDialog.text = artLbl.text
//        stepDialog.text = stepLbl.text
//        savedDialog.text = "\(savedFile)"
        
        let alert = UIAlertController(title: "Save Data", message: "Art : \(artLbl.text!)\nStep : \(stepLbl.text!) \nSaved: \(savedFile)", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in
            textField.placeholder = "input user name"
            
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {[weak alert] (_) in
            let textField = alert?.textFields![0]
            print(textField!.text)
            self.getUserName = textField!.text!
            
            self.writeData()
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Canceled")
        }))
        
        self.present(alert,animated: true,completion: nil)
        
        getFilePath()
        
    }
    
//    func getDocDir() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentdirectory = paths[0]
//        return documentdirectory
//    }
//
//    func getFileUrl() -> URL {
//        let fileNameExt = "attachment.txt"
//        let filepath = getDocDir().appendingPathComponent(fileNameExt)
//        return filepath
//    }
    
    func writeData(){
        for i in 0...typeData.count - 1 {
            
            var writeString = ""
            
            let fileName = "\(getUserName)_\(artSet)_\(step+1)_\(savedFile)_\(typeData[i])"
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
//
            print(fileURL)
            
            print("File Path : \(fileURL.path)")
            for j in 0...getData.count - 1{
                
                
                if i == 0{
                    writeString += "\(getData[j].acceleration.x) \(getData[j].acceleration.y) \(getData[j].acceleration.z)\n"
                }else if i == 1 {
                    writeString += "\(getData[j].gravity.x) \(getData[j].gravity.y) \(getData[j].gravity.z)\n"
                }else if i == 2 {
                    writeString += "\(getData[j].timeLog)\n"
                }
                
            }
            do{
                //                    if FileManager.default.fileExists(atPath: getFileUrl().path) {
                try writeString.write(to:fileURL, atomically: true, encoding: String.Encoding.utf8)
                print(writeString)
                //                    } else {
                //                        // do nothing
                //                    }
            }catch let error as NSError {
                print (error.localizedDescription)
            }
            
        }
        getData = []
        savedFile += 1
        getFilePath()
    }
    
    
  
    
    
    @IBAction func nextStep(_ sender: Any) {
        getData = []
        savedFile = 1
        step += 1
        stepLbl.text = "Step \(step+1)"
        time = stepTimer[artFLag][step]
        timeLbl.text = "\(time)"
    }
    
    
    @IBAction func nextArt(_ sender: Any) {
        getData = []
        savedFile = 1
        savedFile = 1
        artFLag = 1
        artLbl.text = "Tulip Art"
        artSet = "tulip"
        step = 0
        stepLbl.text = "Step \(step+1)"
        time = stepTimer[artFLag][step]
        timeLbl.text = "\(time)"
        
    }
   
    
    func StartRecordData(){
        motionManager.startDeviceMotionUpdates(to: .main) { (data, _) in
            if let coordinate = data {
                let xG = coordinate.gravity.x
                let yG = coordinate.gravity.y
                let zG = coordinate.gravity.z
                let timeLog = coordinate.timestamp
                
                // set default dlu untuk seberapa cepet perpindahan dia untuk latte art
                
                let x = coordinate.userAcceleration.x
                let y = coordinate.userAcceleration.y
                let z = coordinate.userAcceleration.z
                
                self.getData.append(DataModel(acceleration: (x: String(x), y: String(y), z: String(z)), gravity: (x: String(xG), y: String(yG), z: String(zG)), timeLog: String(timeLog)))
                
                print(self.getData[self.getData.count - 1])
                print("jalan terus")
                
                // pake vector coba
                
                
                
                // untuk ngukur posisi
                //                if yG >= -1 && yG <= -0.2 {
                //
                //
                //                }else if yG >= -0.1 && yG <= 0.7 {
                //
                //                }
                
                //ngatur kecepatan dan posisi dia apakah maju ato kebelakang (masi pusing)
                // kecepatan ke kiri dan ke kanan pake koordinat x
                //                if y > 0.2  {
                //                    self.label.text = "Go front"
                //                } else if y < -0.2 {
                //                    self.label.text = "Go back"
                //                }
                
                //
                
                
                
                
            }
            
            // ini untuk coordinate.gravity
            // y dalam gravitasi untuk menentukan tilt ato ga dari hp
            // x dalam gravitasi untuk kiri atau kanan
            // z kebalikan dari y (tapi masi bingung)
            // kalo hp diputer ga bisa kebaca untuk pake gravitasi
            // jadi gravity cuman buat tentuin posisi hp
            // kemiringan hp pada saat posisi bisa dilihat dari x dan z tapi kalo hp dalam posisi tilt dan miring kebawah beda ada pengaruh ke y
            
            
            
            // ini untuk coordinate.userAcceleration (untuk dalam gerakan)
            // untuk ngecek gerakan kiri dan kanan pake x (- atau +)
            // untuk ngecek kedepan dan belakang pake y (- atau +)
            // untuk ngecek kemiringan hp pake z
            
            
            // batasannya adalah dapetin xyz dari accelerometer dan gravity , dan waktu dalam melakukannya (tiap tahap dari latte art)
            // waktu dlu yang harus di train , apakah untuk melakukan stepnya di perlukan waktu seperti data set?
            // abis itu baru di bandingkan tiap elemen dari data set untuk accelerometer untuk tiap stepnya.
        }
    }
    
    func StopRecordData(){
        motionManager.stopDeviceMotionUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        savedFile = 1
        time = stepTimer[artFLag][step]
        
        artLbl.text = "Heart Art"
        artSet = "heart"
        stepLbl.text = "Step \(step+1)"
        timeLbl.text = "\(time)"
        
        
        // Do any additional setup after loading the view.
        //motionManager.gyroUpdateInterval = 0.1
        
        
     
        

//                if myData.rotationRate.x > 2 {
//                    print("xnya adalah \(myData.rotationRate.x)")
//                    print("x = \(myData.rotationRate.x), y = \(myData.rotationRate.y), z = \(myData.rotationRate.z)")
//                }
//
//                if myData.rotationRate.y > 2 {
//                    print("ynya adalah \(myData.rotationRate.y)")
//                    print("x = \(myData.rotationRate.x), y = \(myData.rotationRate.y), z = \(myData.rotationRate.z)")
//                }
//
//                if myData.rotationRate.z > 2 {
//                    print("znya adalah \(myData.rotationRate.z)")
//                    print("x = \(myData.rotationRate.x), y = \(myData.rotationRate.y), z = \(myData.rotationRate.z)")
//                }
//            }
        //}
    
    }

}

