//
//  ViewController.swift
//  Word Scramble
//
//  Created by Rajat Gupta on 30/05/17.
//  Copyright © 2017 Rajat Gupta. All rights reserved.
//

import UIKit
import GameplayKit
import GameplayKit
import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
            else {
                allWords = ["silkworm"]
            }
        }
        else
        {
            loadDefaultWords()
        }
        
        startGame()
        
    }
    func loadDefaultWords() {
        allWords = ["wordscramble"]
    }
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell }
    
    
    func startGame() {
        allWords =
            GKRandomSource.sharedRandom().arrayByShufflingObjects(in:
                allWords) as! [String]
        print("hi")
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message:
            nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit",
                                         style: .default) { [unowned self, ac] (action: UIAlertAction!)
                                            in
                                            let answer = ac.textFields![0]
                                            self.submit(answer: answer.text!)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    
    func isPossible(word: String) -> Bool {
        var tempWord = title!.lowercased()
        for letter in word.characters {
            if let pos = tempWord.range(of: String(letter)) {
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        return true }
    
    func isOriginal(word: String) -> Bool {
        let tempWord = title!.lowercased()

        if(word == tempWord)
        {
            return false
        }
        return !usedWords.contains(word)
    }
    
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in:
            word, range: range, startingAt: 0, wrap: false, language: "en")
        if(word.characters.count<=3)
        {
            return false
        }
        else
        {
            return misspelledRange.location == NSNotFound
        }
    }
    
    func showErrorMessage(errorTitle:String,errorMessage:String){
        
        let ac = UIAlertController(title: errorTitle, message:
            errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath],
                                         with: .automatic)
                    
                    return
                }
                else {
                    showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
                }
            }
            else {
                showErrorMessage(errorTitle: "Word used already", errorMessage: "Be more original!")
            }
        }
        else {
            showErrorMessage(errorTitle: "Word not possible", errorMessage: "You can't spell that word from '\(title!.lowercased())'!")
        
        }
        
    }
}


