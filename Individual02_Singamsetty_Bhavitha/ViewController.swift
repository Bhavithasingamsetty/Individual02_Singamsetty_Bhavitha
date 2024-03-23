//
//  ViewController.swift
//  Individual02_Singamsetty_Bhavitha
//
//  Created by Singamsetty, Bhavitha on 3/22/24.
//
// testing1

import UIKit

class ViewController: UIViewController {

    // Outlets for all UIImageViews and UIButtons
    @IBOutlet var tileImageViews: [UIImageView]! // Connect these outlets in the storyboard
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var showAnswerButton: UIButton!
    
    var blankTileIndex = 19 // Assuming the last tile is the blank one
    let puzzleSize = (columns: 4, rows: 5)
    var originalPositions = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for (index, imageView) in tileImageViews.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tileTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true // Enable interaction
            imageView.tag = index // Tag each imageView to identify it later
            originalPositions = tileImageViews.map { $0.frame.origin }
            
        }
    }
    

    @IBAction func tileTapped(_ sender: UITapGestureRecognizer) {
        print(" Its tapping")
        guard let tappedTile = sender.view, let tappedIndex = tileImageViews.firstIndex(of: tappedTile as! UIImageView) else { return }

        if isTileAdjacentToBlank(tappedIndex) {
            swapTiles(tappedIndex, blankTileIndex)
        }
    }
    
    @IBAction func shuffleTapped(_ sender: UIButton) {
        shuffleTilesRandomly()
    }

    @IBAction func showAnswerTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Show Answer" {
                for (index, imageView) in tileImageViews.enumerated() {
                    imageView.frame.origin = originalPositions[index]
                }
                sender.setTitle("Hide Answer", for: .normal)
            } else {
                // Restore the puzzle to its state before "Show Answer" was tapped
                for imageView in tileImageViews {
                    imageView.frame.origin = originalPositions[tileImageViews.firstIndex(of: imageView)!]
                }
                shuffleTilesRandomly() // Optionally shuffle again or just rearrange to the last state
                sender.setTitle("Show Answer", for: .normal)
            }
    }

    func isTileAdjacentToBlank(_ index: Int) -> Bool {
        let blankRow = blankTileIndex / puzzleSize.columns
        let blankCol = blankTileIndex % puzzleSize.columns
        let tileRow = index / puzzleSize.columns
        let tileCol = index % puzzleSize.columns

        // Check if the tile is directly adjacent (not diagonal) to the blank tile
        let isAdjacentRow = tileRow == blankRow && abs(tileCol - blankCol) == 1
        let isAdjacentCol = tileCol == blankCol && abs(tileRow - blankRow) == 1

        return isAdjacentRow || isAdjacentCol
    }

    func swapTiles(_ firstIndex: Int, _ secondIndex: Int) {
        guard firstIndex >= 0, secondIndex >= 0, firstIndex < tileImageViews.count, secondIndex < tileImageViews.count else { return }

        // Directly swap the frames to change their positions without animation
        let tempFrame = self.tileImageViews[firstIndex].frame
        self.tileImageViews[firstIndex].frame = self.tileImageViews[secondIndex].frame
        self.tileImageViews[secondIndex].frame = tempFrame

        // Swap the tiles in the array to reflect their new order
        tileImageViews.swapAt(firstIndex, secondIndex)

        // Update the blank tile index to reflect its new position
        if firstIndex == blankTileIndex {
            blankTileIndex = secondIndex
        } else if secondIndex == blankTileIndex {
            blankTileIndex = firstIndex
        }
    }


    func shuffleTilesRandomly() {
        print("starting Shuffle")
        var lastBlankIndex = blankTileIndex
            for _ in 0..<100 {
                var adjacentTiles = [Int]()
                if isTileAdjacentToBlank(lastBlankIndex + 1) { adjacentTiles.append(lastBlankIndex + 1) }
                if lastBlankIndex > 0 && isTileAdjacentToBlank(lastBlankIndex - 1) { adjacentTiles.append(lastBlankIndex - 1) }
                if isTileAdjacentToBlank(lastBlankIndex + puzzleSize.columns) { adjacentTiles.append(lastBlankIndex + puzzleSize.columns) }
                if lastBlankIndex >= puzzleSize.columns && isTileAdjacentToBlank(lastBlankIndex - puzzleSize.columns) { adjacentTiles.append(lastBlankIndex - puzzleSize.columns) }
                
                if let newBlankIndex = adjacentTiles.randomElement() {
                    swapTiles(lastBlankIndex, newBlankIndex)
                    lastBlankIndex = newBlankIndex
                }
            }
        print("Shuffle Completed")
    }

    func checkIfPuzzleIsSolved() {
        var solved = true
            for (index, imageView) in tileImageViews.enumerated() {
                if imageView.frame.origin != originalPositions[index] {
                    solved = false
                    break
                }
            }
            if solved {
                // Puzzle is solved, update UI accordingly
                shuffleButton.setTitle("Solved! Shuffle Again?", for: .normal)
                shuffleButton.setTitleColor(.green, for: .normal)
            }
    }
}
