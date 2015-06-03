//
//  ViewController.swift
//  CalculatorAppExample
//
//  Created by 張駿翔 on 6/3/15.
//  Copyright (c) 2015 JackChang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var resutlLabel = UILabel()         //計算結果を表示するラベルを宣言
    let xButtonCount: Int = 4           //1行に配置するボタンの数
    let yButtonCount: Int = 4           //1列に配置するボタンの数
    let screenWidth: Double = Double(UIScreen.mainScreen().bounds.size.width)        //画面の横幅
    let screenHeight: Double = Double(UIScreen.mainScreen().bounds.size.height)      //画面の縦幅
    let buttonMargin = 10.0             //ボタン間の余白（縦）＆（横）
    var resultAreaHeight = 0.0          //計算結果表示エリアの縦幅
    var number1: NSDecimalNumber = 0    //入力数値を格納する変数１
    var number2: NSDecimalNumber = 0    //入力数値を格納する変数２
    var result: NSDecimalNumber = 0     //計算結果を格納する変数
    var operatorId: String = ""         //演算子を格納する変数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blackColor()   //画面の背景色を設定
        //画面全体の横幅に応じて計算結果表示エリアの縦幅を決定
        switch screenHeight {
        case 480:
            resultAreaHeight = 200.0
        case 568:
            resultAreaHeight = 250.0
        case 667:
            resultAreaHeight = 300.0
        case 736:
            resultAreaHeight = 350.0
        default:
            resultAreaHeight = 0.0
        }
        
        //計算結果ラベルのフレームを設定する
        resutlLabel.frame = CGRect(x: 10, y: 30, width: screenWidth-20, height: resultAreaHeight-30)
        //計算結果ラベルの背景色を灰色にする
        resutlLabel.backgroundColor = UIColor.grayColor()
        //計算結果ラベルのフォントと文字サイズを指定
        resutlLabel.font = UIFont(name: "Arial", size: 50)
        //計算結果ラベルのアライメントを右揃えに設定
        resutlLabel.textAlignment = NSTextAlignment.Right
        //計算結果ラベルの表示行数を４桁に設定
        resutlLabel.numberOfLines = 4
        //計算結果ラベルの初期値を”0”に設定
        resutlLabel.text = "0"
        //計算結果ラベルをViewControllerクラスのViewに配置
        self.view.addSubview(resutlLabel)
        
        let buttonLabels = [
            "7", "8", "9", "×",
            "4", "5", "6", "-",
            "1", "2", "3", "+",
            "0", "C", "÷", "=",
        ]
        
        for var y = 0; y < yButtonCount; y++ {
            for var x = 0 ; x < xButtonCount; x++ {
                var button = UIButton()     //計算機のボタンを作成
                //ボタンの横幅サイズ作成
                var buttonWitdh = (screenWidth - (buttonMargin * (Double(xButtonCount)+1))) / Double(xButtonCount)
                //ボタンの縦幅サイズ作成
                var buttonHeight = (screenHeight - resultAreaHeight - ((buttonMargin * Double(yButtonCount)+1))) / Double(yButtonCount)
                //ボタンのX座標
                var butoonPostionX = (screenWidth - buttonMargin) / Double(xButtonCount) * Double(x) + buttonMargin
                //ボタンのY座標
                var buttonPostionY = (screenHeight - resultAreaHeight - buttonMargin) / Double(yButtonCount) * Double(y) + buttonMargin + resultAreaHeight
                //ボタンの配置場所、サイズを指定
                button.frame = CGRect(x: butoonPostionX, y: buttonPostionY, width: buttonWitdh, height: buttonHeight)
                button.backgroundColor = UIColor.greenColor()
                
                //ボタン背景をグラデーション設定
//                var gradient = CAGradientLayer()
//                gradient.frame = button.bounds
//                var arrayColors = [colorWithRGBHex(0xFFFFFF, alpha: 1.0).CGColor]
                

                //ボタンのラベルタイトルを取り出すインデックス番号
                var buttonNumber = y * xButtonCount + x
                //ボタンのラベルタイトルを設定
                button.setTitle(buttonLabels[buttonNumber], forState: UIControlState.Normal)
                //ボタンタップ時のアクション設定
                button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                //ボタンを配置
                self.view.addSubview(button)
            }
        }
    }
    
    func buttonTapped(sender:UIButton) {
        var tappedButtonTitle:String = sender.currentTitle!
        println("\(tappedButtonTitle)ボタンが押されました")
        
        //ボタンのタイトルで条件分岐
        switch tappedButtonTitle {
            case "0","1","2","3","4","5","6","7","8","9":
                numberButtonTapped(tappedButtonTitle)
            case "×","-","+","÷":
                operatorButtonTapped(tappedButtonTitle)
            case "=":
                equalButtonTapped(tappedButtonTitle)
            default:
                clearButtonTapped(tappedButtonTitle)
        }
    }
    
    func numberButtonTapped(tappedButtonTitle: String) {
        println("数字ボタンタップ：\(tappedButtonTitle)")
        //タップされた数字タイトルを計算できるようにDouble型に変換
        var tappedButtonNum: NSDecimalNumber = NSDecimalNumber(string: tappedButtonTitle)
        //入力されていた値を10倍にして１桁大きくして、その変換した数値を加算
        number1 = number1.decimalNumberByMultiplyingBy(NSDecimalNumber(string: "10")).decimalNumberByAdding(tappedButtonNum)
        //計算結果ラベルに表示
        resutlLabel.text = number1.stringValue
    }
    
    func operatorButtonTapped(tappedButtonTitle: String) {
        println("演算子ボタンタップ：\(tappedButtonTitle)")
        operatorId = tappedButtonTitle
        number2 = number1
        number1 = NSDecimalNumber(string: "0")
    }
    
    func equalButtonTapped(tappedButtonTitle: String) {
        println("等号ボタンタップ：\(tappedButtonTitle)")
        switch operatorId {
            case "+":
                result = number2.decimalNumberByAdding(number1)
            case "-":
                result = number2.decimalNumberBySubtracting(number1)
            case "×":
                result = number2.decimalNumberByMultiplyingBy(number1)
            case "÷":
                if(number1.isEqualToNumber(0)) {
                    number1 = 0
                    resutlLabel.text = "無限大"
                    return
                } else {
                    result = number2.decimalNumberByDividingBy(number1)
            }
            default:
                println("その他")
        }
        number1 = result
        resutlLabel.text = String("\(result)")
    }
    
    func clearButtonTapped(tappedButtonTitle: String) {
        println("クリアボタンタップ：\(tappedButtonTitle)")
        number1 = NSDecimalNumber(string: "0")
        number2 = NSDecimalNumber(string: "0")
        result = NSDecimalNumber(string: "0")
        operatorId = ""
        resutlLabel.text = "0"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

