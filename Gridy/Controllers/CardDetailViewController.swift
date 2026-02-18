//
//  CardDetailViewController.swift
//  Gridy
//
//  Created by Julia Morozova on 17. 2. 2026..
//

import UIKit

class CardDetailViewController: UIViewController {
    var card: BoardCard?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        print(card)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
