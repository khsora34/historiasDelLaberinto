import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onClick(_ sender: Any) {
        if let path = Bundle.main.path(forResource: "rooms", ofType: "yml", inDirectory: "ExampleFiles") {
            print(path)
            if let si = try? String.init(contentsOfFile: path) {
                let parser = RoomsFileParser.init()
                if let protagonist = parser.serialize(si) {
                    print(protagonist.rooms)
                }
            }
        }
    }
    
}
