//
//  ViewController.swift
//  diceExpansionSample
//
//  Created by 大島 on 2016/09/11.
//  Copyright © 2016年 taminif. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var centerImage: UIImageView!
    @IBOutlet var rightImage: UIImageView!
    @IBOutlet var gameNumber: UILabel!
    @IBOutlet var hearingLabel: UILabel!
    var tapGesture: UITapGestureRecognizer!

    var isAnimationExec: Bool = false
    var nextStop: Int = 1
    var totalValue: Int = 0
    var beforeValue: Int = 0
    var isBig: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        leftImage.image = UIImage(named: "one")
        centerImage.image = UIImage(named: "two")
        rightImage.image = UIImage(named: "three")

        var imageListArray: Array<UIImage> = []
        imageListArray.append(UIImage(named: "first")!)
        imageListArray.append(UIImage(named: "second")!)
        imageListArray.append(UIImage(named: "third")!)
        imageListArray.append(UIImage(named: "fourth")!)
        imageListArray.append(UIImage(named: "fifth")!)
        imageListArray.append(UIImage(named: "sixth")!)
        leftImage.animationImages = imageListArray
        centerImage.animationImages = imageListArray
        rightImage.animationImages = imageListArray

        // 0.24秒間隔
        let durationValue: Double = 0.24
        leftImage.animationDuration = durationValue
        centerImage.animationDuration = durationValue
        rightImage.animationDuration = durationValue
        // 無限
        let repeatCountValue: Int = 0
        leftImage.animationRepeatCount = repeatCountValue
        centerImage.animationRepeatCount = repeatCountValue
        rightImage.animationRepeatCount = repeatCountValue

        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapAction(_:)))
        self.tapGesture.numberOfTapsRequired = 1
        // デリゲートをセット
        self.tapGesture.delegate = self;
        self.view.addGestureRecognizer(self.tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // タップ用イベント関数
    func tapAction(_ gesture: UIGestureRecognizer) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            // タップが一回でなければ終了
            if tapGesture.numberOfTapsRequired != 1 {
                return
            }
            // アニメーションが開始していなければ終了
            if !isAnimationExec {
                return
            }
            // アニメーションを停止
            let random = arc4random_uniform(6)
            let diceValue = random + 1
            switch nextStop {
            case 1:
                // 左
                leftImage.stopAnimating()
                nextStop += 1
                totalValue += Int(diceValue)
                leftImage.image = getDiceImage(diceValue: diceValue)
                break
            case 2:
                // 中央
                centerImage.stopAnimating()
                nextStop += 1
                totalValue += Int(diceValue)
                centerImage.image = getDiceImage(diceValue: diceValue)
                break
            case 3:
                // 右（全てのアニメーション終了）
                rightImage.stopAnimating()
                nextStop += 1
                totalValue += Int(diceValue)
                rightImage.image = getDiceImage(diceValue: diceValue)
                isAnimationExec = false

                var isSuccess = false
                // 判定
                if isBig {
                    // "BIG"を押した場合
                    if beforeValue <= totalValue {
                        // 前回の数字より大きい場合は成功（同じ値も許容）
                        isSuccess = true
                    }
                } else {
                    // "SMALL"を押した場合
                    if beforeValue >= totalValue {
                        // 前回の数字より小さい場合は成功（同じ値も許容）
                        isSuccess = true
                    }
                }
                if isSuccess {
                    let alert = UIAlertController(title: "結果", message: "成功！", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "次のゲームへ", style:UIAlertActionStyle.default, handler:{(action:UIAlertAction) -> Void in
                        return
                    })
                    alert.addAction(okAction)
                    hearingLabel.isHidden = false
                    beforeValue = totalValue
                    gameNumber.text = beforeValue.description
                    present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "結果", message: "失敗", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "最初から", style:UIAlertActionStyle.default, handler:{(action:UIAlertAction) -> Void in
                        return
                    })
                    alert.addAction(okAction)
                    hearingLabel.isHidden = false
                    beforeValue = 9
                    gameNumber.text = beforeValue.description
                    present(alert, animated: true, completion: nil)
                }

                break
            default:
                break
            }
        }
    }

    @IBAction func smallTouchUpInside(_ sender: AnyObject) {
        startAnimation(isBig: false)
    }

    @IBAction func bigTouchUpInside(_ sender: AnyObject) {
        startAnimation(isBig: true)
    }

    // アニメーションを開始する
    func startAnimation(isBig: Bool) {
        if !isAnimationExec {
            self.isBig = isBig
            // アニメーションを開始
            leftImage.startAnimating()
            centerImage.startAnimating()
            rightImage.startAnimating()
            hearingLabel.isHidden = true
            nextStop = 1
            totalValue = 0
            isAnimationExec = true
        }
    }

    // ダイスの画像を決定する
    func getDiceImage(diceValue: UInt32) -> UIImage {
        var diceImage: UIImage?
        switch diceValue {
        case 1:
            diceImage = UIImage(named: "one")
        case 2:
            diceImage = UIImage(named: "two")
        case 3:
            diceImage = UIImage(named: "three")
        case 4:
            diceImage = UIImage(named: "four")
        case 5:
            diceImage = UIImage(named: "five")
        case 6:
            diceImage = UIImage(named: "six")
        default:
            diceImage = UIImage(named: "one")
        }
        return diceImage!
    }
}

