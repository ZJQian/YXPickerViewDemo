//
//  YXPickerTitleView.swift
//  RuFengVideoEditDemo
//
//  Created by godox on 2020/1/10.
//  Copyright © 2020 YX. All rights reserved.
//

import UIKit

protocol YXPickerTitleViewDelegate {
    func yxpickerTitleDidselect(index: Int)
}

class YXPickerTitleView: UIView {
    
    public var delegate: YXPickerTitleViewDelegate?
    
    var myCollectionView: UICollectionView!
    
    public var titleArray:[String]?
    
    ///红色的动画线条
    private var animationline: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubviews(){
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal        
        myCollectionView  = UICollectionView(frame: CGRect(x: 10, y: 0, width: yx.width - 20, height: yx.height), collectionViewLayout: flowLayout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor .clear
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.alwaysBounceHorizontal = true
        myCollectionView.isPagingEnabled = false
        myCollectionView.register(YXPickerTitleCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(myCollectionView)
        
        let line = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        addSubview(line)
        animationline = UIView()
        animationline.layer.cornerRadius = 1.5
        animationline.clipsToBounds = true
        animationline.backgroundColor = UIColor.red
        line.addSubview(animationline)
        
    }
    
    func setDataTitle(titleArray: [String]){
        self.titleArray = titleArray
        myCollectionView.reloadData()
        
    }
    
  
    func scrollerTitle(index: Int){
        
        let indexPath = IndexPath(row: index, section: 0)
        self.setAnimationLine(index: indexPath)
        
    }
}

extension YXPickerTitleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titleArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YXPickerTitleCell
        
        cell.titleLabel.text = titleArray?[indexPath.row] ?? ""
        
        if titleArray!.count - 1 == indexPath.row{
            cell.titleLabel.textColor = UIColor.red
            let cellRect = self.myCollectionView.convert(cell.frame, to: self.myCollectionView)
            var sdass = self.myCollectionView.convert(cellRect, to: self)
            sdass.size.height = 3.0
            
            UIView.animate(withDuration: 0.3) {
                self.animationline.frame = sdass
            }
        }else{
            cell.titleLabel.textColor = UIColor .black
        }
        
        return cell
        
    }

    
    func setAnimationLine(index: IndexPath){
        
        let cell = self.myCollectionView.cellForItem(at: index) as! YXPickerTitleCell
        let cellRect = self.myCollectionView.convert(cell.frame, to: self.myCollectionView)
        var sdass = self.myCollectionView.convert(cellRect, to: self)
        sdass.size.height = 3.0
        UIView.animate(withDuration: 0.3) {
            self.animationline.frame = sdass
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.delegate != nil{
            self.delegate?.yxpickerTitleDidselect(index: indexPath.row)
        }
        self.setAnimationLine(index: indexPath)
    
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        let titleString = titleArray?[indexPath.row] ?? ""
        let width: CGFloat = titleString.boundingRect(with: CGSize(width: 0, height: self.frame.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil).width
        return CGSize(width: width + 10.0, height: 30)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    

}