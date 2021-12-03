//
//  ViewController.swift
//  WalE
//
//  Created by sanket ingole on 01/12/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var discLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertDesc: UILabel!
    
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearLabel()
        self.viewModel.delegate = self
        viewModel.getNasaData()
        self.alertView.isHidden = true
    }
    
    func clearLabel() {
        self.dateLabel.text = ""
        self.discLabel.text = ""
        self.titleLabel.text = ""
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        self.alertView.isHidden = true
    }
    
}

extension ViewController : WalEMainControllerDelegate {
    func dataLoadingErrorWith(msg: String) {
        DispatchQueue.main.async { [weak self] in
            self?.alertView.isHidden = false
            self?.alertDesc.text = msg
        }
    }
    
    
    func loadImageFromData(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
        }
    }
    
    func loadJsonData() {
        DispatchQueue.main.async { [weak self] in
            self?.discLabel.text = self?.viewModel.dataObject?.explanation
            self?.titleLabel.text = self?.viewModel.dataObject?.title
            self?.dateLabel.text = self?.viewModel.dataObject?.date
        }
    }
    
}
