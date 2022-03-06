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
    
    var words = ["CHECK", "HAPPY", "SEVEN", "HELLO", "SEVEN", "HEART", "AGAIN", "PIZZA", "WATER", "BOARD", "MONTH", "DEATH", "ANGEL", "GREEN", "MUSIC", "THREE", "PARTY", "PIANO", "MOUTH", "SUGAR", "DREAM", "APPLE", "LAUGH", "TIGER", "FAITH", "EARTH", "RIVER", "WORDS", "SMILE", "HOUSE", "ALONE", "WATCH", "LEMON", "JESUS", "ADMIN", "STONE", "BLOOD", "LIGHT", "STORY", "APRIL", "CANDY", "PHONE", "PUPPY", "VEGAN", "BIRTH", "QUEEN", "MAGIC", "KNIFE", "BLACK", "CYCLE", "TRUTH", "ZEBRA", "TRAIN", "BRAIN", "UNDER", "DIRTY"]
    
    var wordString = ""
    var wordArray = [String] ()
    var wordMap = [String: Int] ()
    
    var currentRow: Int = 0
    var currentColumn: Int = 0
    
    var wordMatrix = [[String]] ()
    var wordMatrixState = [[Int]] ()
    
    var buttonMap = [String: UIButton]()
    var keyboardStateMap = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in keyboardButtons {
            button.addTarget(self, action: #selector(onKeyboardButtonClick), for: .touchUpInside)
        }
        
        wordMatrix = Array(repeating: Array(repeating: "", count: 5), count: 6)
        wordMatrixState = Array(repeating: Array(repeating: 0, count: 5), count: 6)
        
        wordMatrixCollection.delegate = self
        wordMatrixCollection.dataSource = self
        
        initNewWord()
    }
    
    func initNewWord() {
        submitButton.isEnabled = false
        
        wordString = words.randomElement()!
        wordArray.removeAll()
        wordMap.removeAll()
        
//        print("New word:", wordString)
        
        for ch in wordString {
            let chStr = ch.description
            wordArray.append(chStr)
            
            if let count = wordMap[chStr] {
                wordMap[chStr] = count + 1
            } else {
                wordMap[chStr] = 1
            }
        }
        
        for i in 0...5 {
            for j in 0...4 {
                wordMatrix[i][j] = ""
                wordMatrixState[i][j] = 0
            }
        }
        
        buttonMap.removeAll()
        keyboardStateMap.removeAll()
        
        currentRow = 0
        currentColumn = 0
        
        for button in keyboardButtons {
            button.tintColor = UIColor.lightGray
        }
        
        wordMatrixCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LetterCollectionViewCell.identifier,
            for: indexPath
        ) as! LetterCollectionViewCell
        
        let row = indexPath.row/5
        let col = indexPath.row%5

        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        if row == currentRow && col == currentColumn {
            cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        cell.letterLabel.text = wordMatrix[row][col]
        
        cell.contentView.backgroundColor = getCellColor(wordMatrixState[row][col])
        
        return cell
    }
    
    func getCellColor(_ state: Int) -> UIColor {
        var cellColor: UIColor = UIColor.clear
        switch state {
        case 3:
            cellColor = UIColor.systemCyan
        case 2:
            cellColor = UIColor.orange
        case 1:
            cellColor = UIColor.gray
        default:
            cellColor = UIColor.clear
        }
        return cellColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (wordMatrixCollection.frame.size.width/5)-5,
            height: (wordMatrixCollection.frame.size.width/5)-5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1 )
    }
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Section: \(indexPath.section) Row: \(indexPath.row)")
    }
    
    @objc func onKeyboardButtonClick(_ sender: UIButton) {
        
        var matrixChanged = false
        
        if let character = sender.titleLabel?.text {
            if currentColumn < 5 {
                wordMatrix[currentRow][currentColumn] = character
                
                currentColumn += 1
                matrixChanged = true
                
                buttonMap[character] = sender
            }
        } else {
            if currentColumn > 0 {
                currentColumn -= 1
                
                wordMatrix[currentRow][currentColumn] = ""
                
                matrixChanged = true
            }
        }
        
        submitButton.isEnabled = currentColumn == 5
        
        if matrixChanged {
            wordMatrixCollection.reloadData()
        }
    }

    @IBAction func onSubmit(_ sender: UIButton) {
        submitButton.isEnabled = false
        var correctGuess = true
        var wordMapLocal = wordMap
        
        // Logic
        let guessedWordArr = wordMatrix[currentRow]
        
        for i in 0...4 {
            if guessedWordArr[i] == wordArray[i].description {
                wordMatrixState[currentRow][i] = 3
                if let count = wordMapLocal[guessedWordArr[i]] {
                    wordMapLocal[guessedWordArr[i]] = count - 1
                }
                
                keyboardStateMap[guessedWordArr[i]] = 3
                buttonMap[guessedWordArr[i]]?.tintColor = getCellColor(keyboardStateMap[guessedWordArr[i]]!)
            }
        }
        
        for i in 0...4 {
            if wordMatrixState[currentRow][i] == 3 {
                continue
            }
            
            if let count = wordMapLocal[guessedWordArr[i]], count > 0 {
                correctGuess = false
                wordMatrixState[currentRow][i] =  2
                wordMapLocal[guessedWordArr[i]]! -= 1
            } else {
                correctGuess = false
                wordMatrixState[currentRow][i] = 1
            }
            
            keyboardStateMap[guessedWordArr[i]] = max(keyboardStateMap[guessedWordArr[i]] ?? 0, wordMatrixState[currentRow][i])
            buttonMap[guessedWordArr[i]]?.tintColor = getCellColor(keyboardStateMap[guessedWordArr[i]]!)
        }
        
        buttonMap.removeAll()
        wordMatrixCollection.reloadData()
        
        currentRow += 1
        currentColumn = 0
        
        if correctGuess {
            // Alert of correct guess
            let alert = UIAlertController(title: "Correct!", message: "Your guesss was correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (_) in
                self.initNewWord()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if currentRow == 6 {
            let alert = UIAlertController(title: "Incorrect!", message: "Correct Word was " + wordString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (_) in
                self.initNewWord()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

