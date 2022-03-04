//
//  ViewController.swift
//  Project1_Wordus
//
//  Created by Krunal Shah on 2022-03-01.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var wordMatrixCollection: UICollectionView!
    @IBOutlet var keyboardButtons: [UIButton]!
    @IBOutlet weak var submitButton: UIButton!
    
    var word = ["CHECK"]
    
    var currentRow: Int = 0
    var currentColumn: Int = 0
    
    var wordMatrix = [[String]] ()
    var checkingMatrix = [[Int]] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in keyboardButtons {
            button.addTarget(self, action: #selector(onKeyboardButtonClick), for: .touchUpInside)
        }
        
        wordMatrix = Array(repeating: Array(repeating: "", count: 5), count: 6)
        checkingMatrix = Array(repeating: Array(repeating: 0, count: 5), count: 6)
        
        wordMatrixCollection.delegate = self
        wordMatrixCollection.dataSource = self
        
        submitButton.isEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LetterCollectionViewCell.identifier,
            for: indexPath
        ) as! LetterCollectionViewCell
        
//        cell.letterLabel.text = "S"
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.letterLabel.text = wordMatrix[(indexPath.row+1)/6][indexPath.row%5]
        
//        print(indexPath.row/6, indexPath.row%5, indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (wordMatrixCollection.frame.size.width/5)-5,
            height: (wordMatrixCollection.frame.size.width/5)-5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1 )
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Section: \(indexPath.section) Row: \(indexPath.row)")
    }
    
    @objc func onKeyboardButtonClick(_ sender: UIButton) {
//        print(sender.titleLabel?.text ?? "ABCD")
        
        var matrixChanged = false
        
        if let character = sender.titleLabel?.text {
            if currentColumn < 5 {
                wordMatrix[currentRow][currentColumn] = character
                
                currentColumn += 1
                matrixChanged = true
            }
        } else {
            if currentColumn > 0 {
                currentColumn -= 1
                
                wordMatrix[currentRow][currentColumn] = ""
                
                matrixChanged = true
            }
        }
        
        if currentColumn == 5 {
            submitButton.isEnabled = true
        }
        
        if matrixChanged {
            wordMatrixCollection.reloadData()
            print(wordMatrix)
        }
    }

    @IBAction func onSubmit(_ sender: UIButton) {
        submitButton.isEnabled = false
        
        currentRow += 1
        currentColumn = 0
    }
}

