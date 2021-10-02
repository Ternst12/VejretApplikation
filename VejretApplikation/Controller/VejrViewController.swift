
import UIKit
import CoreLocation

class VejrViewController: UIViewController, CLLocationManagerDelegate { // Delegate Protocol

    @IBOutlet weak var vejrIkon: UIImageView!
    @IBOutlet weak var temperaturLabel: UILabel!
    @IBOutlet weak var byLabel: UILabel!
    
    @IBOutlet weak var søgFelt: UITextField!
    
    var vejrManager = VejrManager()
    let locationManager = CLLocationManager() // Ansvarlig for at spore telefonens aktuelle lokation
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // Skal komme før request
        
        locationManager.requestWhenInUseAuthorization() // husk at tilføje property i info property liste
        
        locationManager.requestLocation()
        
        vejrManager.delegate = self // Gør vejrmanager modellen tilgængelig for controlleren
        søgFelt.delegate = self // Kommunikerer med viewcontrolleren når brugeren interagerer med søgefeltet
        
            
        }
        @IBAction func placeringPressed(_ sender: UIButton) {
        
            locationManager.requestLocation()
            
        }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Har fundet den aktuelle placering")
        if let placering = locations.last {
            
            locationManager.stopUpdatingLocation()
            let lat = placering.coordinate.latitude
            let lon = placering.coordinate.longitude
            
            vejrManager.fetchVejr(latitude: lat, longitute: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

//MARK: UITextFieldDelegate

extension VejrViewController: UITextFieldDelegate {
    @IBAction func søgKnap(_ sender: UIButton) {
        søgFelt.endEditing(true) // lukker keyboarded efter brug
        print(søgFelt.text!)
    }
    
    // Funktion kaldes når brugeren trykker på seach knappen i keyboarded
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        søgFelt.endEditing(true)
        print(søgFelt.text!)
        return true
    }
    
    // Sætter tekstfeltet tilbage på default efter søgning
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let by = søgFelt.text {
            vejrManager.fetchVejr(byNavn: by)
        }
        
        søgFelt.text = ""
    }
    
    //Validering om brugeren har skrevet noget
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        } else {
            textField.placeholder = "Skriv navnet på en by"
            return false
        }
    }
}
//MARK: - VejrManagerDelegate

extension VejrViewController: VejrManagerDelegate {
    func updaterVejrData(vejret: VejrModel){ //
        
        DispatchQueue.main.async { // Asyncron funktion VejrManager kører i baggrunden, og venter med at updaterer UI til fetch fra API er færdig
            print("Controlleren har nu adgang til vejr data")
            print(vejret.temperaturString)
            self.temperaturLabel.text = vejret.temperaturString
            self.vejrIkon.image = UIImage(systemName: vejret.vejrBeskrivelse)
            self.byLabel.text = vejret.byNavnet
        }
        
    }
    
    func derErFejl(error: Error) {
        print("Der er sket en fejl")
        print(error)
    }
}
