//
//  InterfaceController.swift
//  Guess WatchKit Extension
//
//  Created by Liudong on 15/4/21.
//  Copyright (c) 2015年 Liudong. All rights reserved.
//

import WatchKit
import Foundation

enum Times:Int {
    case Lose = 0 // 猜错大小 并且数字匹配 倍数乘0
    case Win = 2 // 猜对大小 但数字不匹配 倍数乘2
    case Match = 10  // 猜对大小,并且数字 倍数乘10
}

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var sliderGuess: WKInterfaceSlider!
    @IBOutlet weak var guessNumberLabel: WKInterfaceLabel!
    @IBOutlet weak var bonusLabel: WKInterfaceLabel!
    
    @IBOutlet weak var chargeButton: WKInterfaceButton!
    @IBOutlet weak var playeButton: WKInterfaceButton!
    
    @IBOutlet weak var resultLabel: WKInterfaceLabel! // 结果
    
    var guessNumber = 1 //当前选中的点数
    var times = 1 //赔率倍数
    
    // 金钱数量
    var bouns = 100 {
        didSet{
            if bouns == 0 {
                self.chargeButton.setHidden(false)
                self.playeButton.setHidden(true)
            } else {
                self.chargeButton.setHidden(true)
                self.playeButton.setHidden(false)
            }
            bonusLabel.setText("金钱:\(bouns)")
        }
        willSet {
            bonusLabel.setText("金钱:\(newValue)")
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.chargeButton.setHidden(true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    // 选择点数
    @IBAction func updateGuessNumber(value: Float) {
        guessNumber = Int(value)
        
        var isbigstr =  self.isBig(self.guessNumber).1 // 获取返回元组返回值, 0为第一个值，1为第二个值
        self.guessNumberLabel.setText("猜 \(self.guessNumber) \(isbigstr)")
        
    }
    
    // 充值
    @IBAction func chargeBounus() {
        self.bouns = 1000
        resultLabel.setText("结果")
        playeButton.setTitle("猜一下")
    }
    
    
    // 开始玩
    @IBAction func startGuess() {
        self.playeButton.setTitle("再来一把")
        
        // 产生随机数
        var randomNumber = Int (arc4random_uniform(9) + 1)
        
        println("randomNumber : \(randomNumber)")
        
        // 是否猜中
        if isBig(guessNumber).0 == isBig(randomNumber).0 {
            
            if guessNumber != randomNumber {
                resultLabel.setText("\(randomNumber),恭喜奖金x2")
                times = Times.Win.rawValue
                
            } else {
                resultLabel.setText("\(randomNumber)你太厉害了,奖金x10")
                times = Times.Match.rawValue
            }
            
        } else {
            resultLabel.setText("\(randomNumber),很遗憾!")
            times = Times.Lose.rawValue
            bouns = bouns * times
        }
        
        //奖励值变化 等于 原奖励值 乘以 本次应有的倍数
        bouns = bouns * times
        
    }
    
    // 判断大小
    func isBig(number:Int) ->(Bool, String) {
        return number > 5 ? (true,"大") : (false, "小")
    }
}
