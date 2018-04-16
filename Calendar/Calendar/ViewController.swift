//
//  ViewController.swift
//  Calendar
//
//  Created by user37 on 2018/2/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var calendar: UICollectionView!
    @IBOutlet weak var yearMonLabel: UILabel!
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var numberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year: currentYear ,month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,for: date)
        
        return range?.count ?? 0
    }
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year: currentYear ,month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInThisMonth+whatDayIsIt-1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let textLabel = cell.contentView.subviews[0] as? UILabel {
            if indexPath.row < whatDayIsIt-1 {
                textLabel.text = ""
            } else {
                textLabel.text = "\(indexPath.row-whatDayIsIt+2)"
            }
            
            if currentYear < Calendar.current.component(.year, from: Date()) {
                textLabel.textColor = UIColor.orange
            } else if currentYear > Calendar.current.component(.year, from: Date()){
                textLabel.textColor = UIColor.yellow
            } else {
                if currentMonth < Calendar.current.component(.month, from: Date()) {
                    textLabel.textColor = UIColor.orange
                } else if currentMonth > Calendar.current.component(.month, from: Date()){
                    textLabel.textColor = UIColor.yellow
                } else {
                    if indexPath.row-whatDayIsIt+2 < Calendar.current.component(.day, from: Date()) {
                        textLabel.textColor = UIColor.orange
                    } else {
                        textLabel.textColor = UIColor.yellow
                    }
                }
            }
        }
        return cell
    }
    //MARK: UICollectionViewDelegateFlowLayout
    //間隔=0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //行距=0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //cell寬高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: 40)
    }
    
    func setMonthAndYear() {
        print(currentYear)
        print(currentMonth)
        calendar.reloadData()
        yearMonLabel.text = months[currentMonth - 1] + " \(currentYear)"
        if currentYear < Calendar.current.component(.year, from: Date()) {
            yearMonLabel.textColor = UIColor.orange
        } else if currentYear > Calendar.current.component(.year, from: Date()){
            yearMonLabel.textColor = UIColor.yellow
        } else {
            if currentMonth < Calendar.current.component(.month, from: Date()) {
                yearMonLabel.textColor = UIColor.orange
            } else {
                yearMonLabel.textColor = UIColor.yellow
            }
        }
    }
    
    @IBAction func pastBtn(_ sender: Any) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
        setMonthAndYear()
    }
    @IBAction func nextBtn(_ sender: Any) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        setMonthAndYear()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        //navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        setMonthAndYear()
        let dateComponents = DateComponents(year: currentYear ,month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,for: date)!
        print(dateComponents)
        print(date)
        print(range.count)
        print(Date())
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.calendar.collectionViewLayout.invalidateLayout()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


