//
//  ViewController.swift
//  Sensores Example
//
//  Created by marco alonso on 07/01/0.51.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var girosX: UILabel!
    @IBOutlet weak var girosY: UILabel!
    @IBOutlet weak var girosZ: UILabel!
    @IBOutlet weak var aceleX: UILabel!
    @IBOutlet weak var aceleY: UILabel!
    @IBOutlet weak var aceleZ: UILabel!
    
    var motion = CMMotionManager()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MiGiroscopio()
        MiAcelerometro()
        
    }
    
    func MiGiroscopio() {
        //cada cuanto tiempo detecta un cambio en seg.
        motion.gyroUpdateInterval = 0.5
        motion.startGyroUpdates(to: OperationQueue.current!) { ( data, error)  in
            if let hayDatos = data {
                
                if (hayDatos.rotationRate.x > 1) || (hayDatos.rotationRate.y > 2) || (hayDatos.rotationRate.z > 1 ) {
                    //ejecutar sonido
                    if let player = self.player, player.isPlaying {
                        //detener
                        //                        player.stop()
                    } else {
                        // play
                        let urlString = Bundle.main.path(forResource: "iphone-notificacion", ofType: "mp3")
                        
                        do {
                            try AVAudioSession.sharedInstance().setMode(.default)
                            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                            
                            guard let urlString = urlString else {
                                return
                            }
                            
                            self.player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                            
                            guard let player = self.player else {
                                return
                            }
                            
                            player.play()
                        }
                        catch {
                            print("Algo ocurrio mal!")
                        }
                    }
                }
                
                self.girosX.text = "\(hayDatos.rotationRate.x)"
                self.girosY.text = "\(hayDatos.rotationRate.y)"
                self.girosZ.text = "\(hayDatos.rotationRate.z)"
                print(hayDatos)
                
            }
        }
    }
    
    func MiAcelerometro() {
        motion.accelerometerUpdateInterval = 0.5
        motion.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let trueData = data {
                print(trueData)
                self.aceleX.text = "\(trueData.acceleration.x)"
                self.aceleY.text = "\(trueData.acceleration.y)"
                self.aceleZ.text = "\(trueData.acceleration.z)"
            }
        }
    }


}

